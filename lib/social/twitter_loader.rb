class TweetsLoader
  def load(options = {})
    count = options[:count] || 6
    client.search("@fameandpartners OR #fameandpartners OR from:fameandpartners", result_type: 'recent').take(count)
  end

  private

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = configatron.twitter.consumer_key
      config.consumer_secret     = configatron.twitter.consumer_secret
      config.access_token        = configatron.twitter.access_token
      config.access_token_secret = configatron.twitter.access_token_secret
    end
  end
end
