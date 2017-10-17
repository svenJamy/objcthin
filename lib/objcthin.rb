require "objcthin/version"
require 'thor'
require 'rainbow'

module Objcthin

  class Command < Thor

    desc'version','print version'
    def version
      puts Objcthin::VERSION.red
    end
  end
  
end
