require 'elasticsearch/persistence'

class Trove::ProductRepository
  include Elasticsearch::Persistence::Repository
  attr_accessor :options

  def initialize(options={})
    @options = options
    index  'products_test_0_0_1'
    client Elasticsearch::Client.new(url: configatron.es_url, log: true)
  end

  def query
    @query ||= Trove::ProductQuery.new(options).build
  end

  def products
    @results ||= search(query).results
  end

  def deserialize(document)
    document['_source']
  end

end
