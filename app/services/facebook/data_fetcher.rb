class Facebook::DataFetcher

  attr_accessor :graph

  def initialize(token)
    self.graph = Koala::Facebook::API.new(token)
  end

  def fetch_friends
    all_friends = []

    friends = self.graph.get_connection('me', 'friends')

    while friends.present?
      all_friends.concat friends
      friends = friends.next_page
    end

    all_friends
  end

  def fetch_gender
    self.graph.get_object('me')['gender']
  end

end
