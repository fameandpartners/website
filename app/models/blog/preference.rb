class Blog::Preference < ActiveRecord::Base
  attr_accessible :key, :value

  validates :key, presence: true

  class << self
    def update_preference(key, value)
      record = self.where(key: key).first_or_initialize
      record.value = value
      record.save
    end

    def defaults
      {
        song_id:    '103699725',
        song_title: 'soundcloud title', 
        song_description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor.',
        homepage_quote: 'featured quote, lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor',
        homepage_quote_author: 'first name - last name',
        homepage_video_url: '//www.youtube.com/embed/4j3u9fxHMkI'
      }
    end
  end
end
