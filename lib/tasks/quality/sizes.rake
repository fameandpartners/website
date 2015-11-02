require 'log_formatter'

namespace :quality do
  desc 'Move to explicit sizes'
  task :normalise_sizes => :environment do

    new_logger = Logger.new($stdout)
    new_logger.level     = Logger::INFO
    new_logger.formatter = LogFormatter.terminal_formatter
    new_logger

    LineItemSizeNormalisation.fully_hydrated.find_each do |lisn|
      lisn.logger = new_logger
      lisn.find_new_variant
      lisn.convert_size!
      lisn.save
    end
  end
end
