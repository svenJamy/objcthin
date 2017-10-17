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
      find_impl_methods(path)
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
      # imp -[class sel]
      patten = /\s*imp\s*([+|-]\[.+\s(.+)\])/

      output = `/usr/bin/otool -oV #{path}`

      output.each_line do |line|
        patten.match(line) do |m|
          puts m[0], m[1]
        end
      end

    end

  end
end
