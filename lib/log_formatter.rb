require 'term/ansicolor'

module LogFormatter
  include Term::ANSIColor

  module_function
  def terminal_formatter
    -> (severity, datetime, _progname, msg) do
      color = {
        'ERROR' => Term::ANSIColor.red,
        'WARN' => Term::ANSIColor.magenta}.fetch(severity) { '' }

      "%s[%s] [%-5s] %s%s\n" % [ color,
                                 datetime.strftime('%Y-%m-%d %H:%M:%S'),
                                 severity,
                                 msg,
                                 Term::ANSIColor.reset]
    end
  end
end
