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

    def initialize(csv_file, logdev = STDOUT)
      @csv_file = csv_file

      @logger = Logger.new(logdev)
      @logger.level = Logger::INFO unless ENV['debug']
      @logger.formatter = LogFormatter.terminal_formatter
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
