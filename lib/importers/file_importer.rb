require 'csv'
require 'active_support/all'
require 'forwardable'
require 'term/ansicolor'

module Importers
  class FileImporter

    include Term::ANSIColor
    extend Forwardable
    def_delegators :@logger, :info, :debug, :warn, :error, :fatal

    attr_reader :csv_file

    def initialize(csv_file)
      @csv_file = csv_file

      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO unless ENV['debug']
      @logger.formatter = proc do |severity, datetime, _progname, msg|
        color = {'ERROR' => red, 'WARN' => magenta}.fetch(severity) { '' }
        "%s[%s] [%-5s] %s%s\n" % [color, datetime.strftime('%Y-%m-%d %H:%M:%S'), severity, msg, reset]
      end
    end

    def import
      error "Not Implemented"
    end

    def preface
      info "#{self.class.name} Start"
      info "File: #{csv_file}"
    end
  end
end
