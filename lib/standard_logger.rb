require 'term/ansicolor'

class StandardLogger

  include Term::ANSIColor

  def self.logger(logdev = $stdout)
    logger = Logger.new(logdev)
    logger.level = Logger::INFO unless ENV['debug']
    logger.formatter = proc do |severity, datetime, _progname, msg|
      color = {'ERROR' => red, 'WARN' => magenta}.fetch(severity) { '' }
      "%s[%s] [%-5s] %s%s\n" % [color, datetime.strftime('%Y-%m-%d %H:%M:%S'), severity, msg, reset]
    end
    logger
  end
end
