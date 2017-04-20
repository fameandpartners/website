Elasticsearch::Persistence.client = Elasticsearch::Client.new host: configatron.es_url || 'localhost:9200'

if Rails.env.development?
    logger           = ActiveSupport::Logger.new(STDERR)
      logger.level     = Logger::INFO
        logger.formatter = proc { |s, d, p, m| "\e[2m#{m}\n\e[0m" }
          Elasticsearch::Persistence.client.transport.logger = logger
end

