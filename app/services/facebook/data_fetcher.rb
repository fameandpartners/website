require 'json'
require 'open-uri'

class Facebook::DataFetcher
  attr_accessor :uid
  attr_accessor :token

  def initialize(uid, token)
    self.uid = uid
    self.token = token
  end

  def fetch_birthday
    response = get(nil, fields: 'birthday')

    if response['birthday'].present?
      Date.strptime(response['birthday'], '%m/%d/%Y')
    else
      nil
    end
  end

  def fetch_friends
    friends = []
    limit   = 1000
    offset  = 0

    loop do
      response = get('friends', limit: limit, offset: offset)

      friends += response['data']

      break if response['data'].size < limit

      offset += limit
    end

    friends
  end

  def fetch_gender
    response = get('/', fields: 'gender')
    response['gender']
  end

  private

  def get(path = nil, params = {})
    url = [base_url, path].compact.join('/')
    url += "?#{params.merge(access_token: token).to_params}"

    JSON.parse(open(url).read)
  end

  def base_url
    "https://graph.facebook.com/#{uid}"
  end
end
