require "objcthin/version"
require 'thor'
require 'rainbow'
require 'pathname'

module Objcthin
  class Command < Thor
    desc 'findsel','find unused method sel'
    def findsel(path)
      Imp::Objc.find_unused_sel(path)
    end

    desc 'findclass', 'find unused class list'
    def findclass(path)
      Imp::Objc.find_unused_class(path)
    end

    desc'version','print version'
    def version
      puts Rainbow(Objcthin::VERSION).green
    end
  end
end

module Imp
  class Objc
    def self.find_unused_sel(path)
      check_file_type(path)
      all_sels = find_impl_methods(path)
      used_sel = reference_selectors(path)

      unused_sel = []

      all_sels.each do |sel,class_and_sels|
        unless used_sel.include?(sel)
          unused_sel += class_and_sels
        end
      end

      puts Rainbow('below selector is unused:\n').red

      puts unused_sel
    end

    def self.find_unused_class(path)
      check_file_type(path)
    end

    def self.check_file_type(path)
      pathname = Pathname.new(path)
      unless pathname.exist?
        raise "#{path} not exit!"
      end

      cmd = "/usr/bin/file -b #{path}"
      output = `#{cmd}`

      unless output.include?('Mach-O')
        raise 'input file not mach-o file type'
      end
      puts Rainbow('will begin process...').green
      pathname
    end

    def self.find_impl_methods(path)

      app = %w[1 2]

      apple_protocols = [
          'tableView:canEditRowAtIndexPath:',
      'commitEditingStyle:forRowAtIndexPath:',
      'tableView:viewForHeaderInSection:',
      'tableView:cellForRowAtIndexPath:',
      'tableView:canPerformAction:forRowAtIndexPath:withSender:',
      'tableView:performAction:forRowAtIndexPath:withSender:',
      'tableView:accessoryButtonTappedForRowWithIndexPath:',
      'tableView:willDisplayCell:forRowAtIndexPath:',
          'tableView:commitEditingStyle:forRowAtIndexPath:',
          'tableView:didEndDisplayingCell:forRowAtIndexPath:',
          'tableView:didEndDisplayingHeaderView:forSection:',
          'tableView:heightForFooterInSection:',
          'tableView:shouldHighlightRowAtIndexPath:',
          'tableView:shouldShowMenuForRowAtIndexPath:',
          'tableView:viewForFooterInSection:',
          'tableView:willDisplayHeaderView:forSection:',
          'tableView:willSelectRowAtIndexPath:',
          'willMoveToSuperview:',
      'numberOfSectionsInTableView:',
      'actionSheet:willDismissWithButtonIndex:',
      'gestureRecognizer:shouldReceiveTouch:',
      'gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:',
      'gestureRecognizer:shouldReceiveTouch:',
      'imagePickerController:didFinishPickingMediaWithInfo:',
      'imagePickerControllerDidCancel:',
      'animateTransition:',
      'animationControllerForDismissedController:',
      'animationControllerForPresentedController:presentingController:sourceController:',
      'navigationController:animationControllerForOperation:fromViewController:toViewController:',
      'navigationController:interactionControllerForAnimationController:',
      'alertView:didDismissWithButtonIndex:',
      'URLSession:didBecomeInvalidWithError:',
      'setDownloadTaskDidResumeBlock:',
      'tabBarController:didSelectViewController:',
      'tabBarController:shouldSelectViewController:',
      'applicationDidReceiveMemoryWarning:',
      'application:didRegisterForRemoteNotificationsWithDeviceToken:',
      'application:didFailToRegisterForRemoteNotificationsWithError:',
      'application:didReceiveRemoteNotification:fetchCompletionHandler:',
      'application:didRegisterUserNotificationSettings:',
      'application:performActionForShortcutItem:completionHandler:',
      'application:continueUserActivity:restorationHandler:'].freeze

      # imp -[class sel]
      sub_patten = /[+|-]\[.+\s(.+)\]/
      patten = /\s*imp\s*(#{sub_patten})/
      sel_set_patten = /set[A-Z].*:$/
      sel_get_patten = /is[A-Z].*/

      output = `/usr/bin/otool -oV #{path}`

      imp = {}

      output.each_line do |line|
        patten.match(line) do |m|
          sub = sub_patten.match(m[0]) do |subm|
            class_and_sel = subm[0]
            sel = subm[1]

            next if sel.start_with?('.')
            next if apple_protocols.include?(sel)
            next if sel_set_patten.match?(sel)
            next if sel_get_patten.match?(sel)

            if imp.has_key?(sel)
              imp[sel] << class_and_sel
            else
              imp[sel] = [class_and_sel]
            end
          end
        end
      end

      imp.sort
    end

    def self.reference_selectors(path)
      patten = /__TEXT:__objc_methname:(.+)/
      output = `/usr/bin/otool -v -s __DATA __objc_selrefs #{path}`

      sels = []
      output.each_line do |line|
        patten.match(line) do |m|
          sels << m[1]
        end
      end

      sels
    end

  end
end
