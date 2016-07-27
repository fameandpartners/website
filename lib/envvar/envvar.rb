###
# Thank you [dotenv-rails](https://github.com/bkeepers/dotenv) for the code contained in this module
#
# Description:
#  dotenv-rails and spree (deface) 1.3 donot work well together so this hack
#  was implemented to replcae the need for dotenv-rails
#
# Called by {app_root}/config/application.rb
#
module Envvar
  def self.load(env_file)
    env = Envvar::Environment.new(env_file)
    env.apply
  end

  class FormatError < SyntaxError; end

  # This class enables parsing of a string for key value pairs to be returned
  # and stored in the Environment.
  class Parser
    LINE = /
      \A
      (?:export\s+)?    # optional export
      ([\w\.]+)         # key
      (?:\s*=\s*|:\s+?) # separator
      (                 # optional value begin
        '(?:\'|[^'])*'  #   single quoted value
        |               #   or
        "(?:\"|[^"])*"  #   double quoted value
        |               #   or
        [^#\n]+         #   unquoted value
      )?                # value end
      (?:\s*\#.*)?      # optional comment
      \z
    /x

    class << self
      def call(string)
        new(string).call
      end
    end

    def initialize(string)
      @string = string
      @hash = {}
    end

    def call
      @string.split(/[\n\r]+/).each do |line|
        parse_line(line)
      end
      @hash
    end

    private

    def parse_line(line)
      if (match = line.match(LINE))
        key, value = match.captures
        @hash[key] = parse_value(value || "")
      elsif line.split.first == "export"
        if variable_not_set?(line)
          raise FormatError, "Line #{line.inspect} has an unset variable"
        end
      elsif line !~ /\A\s*(?:#.*)?\z/ # not comment or blank line
        raise FormatError, "Line #{line.inspect} doesn't match format"
      end
    end

    def parse_value(value)
      # Remove surrounding quotes
      value = value.strip.sub(/\A(['"])(.*)\1\z/, '\2')

      if Regexp.last_match(1) == '"'
        value = unescape_characters(expand_newlines(value))
      end

      value
    end

    def unescape_characters(value)
      value.gsub(/\\([^$])/, '\1')
    end

    def expand_newlines(value)
      value.gsub('\n', "\n").gsub('\r', "\r")
    end

    def variable_not_set?(line)
      !line.split[1..-1].all? { |var| @hash.member?(var) }
    end
  end

  # This class inherits from Hash and represents the environment into which
  # Dotenv will load key value pairs from a file.
  class Environment < Hash
    attr_reader :filename

    def initialize(filename)
      @filename = filename
      load
    end

    def load
      update Parser.call(read)
    end

    def read
      File.open(@filename, "rb:bom|utf-8", &:read)
    end

    def apply
      each { |k, v| ENV[k] ||= v }
    end

    def apply!
      each { |k, v| ENV[k] = v }
    end
  end
end
