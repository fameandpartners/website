class BlogController < BlogBaseController
  def index
    title
    description

    #@promo_banners        = Blog::PromoBanner.published.all
    #@latest_photos        = Blog::CelebrityPhoto.latest
    #@featured_posts       = Blog::Post.featured
    #if current_spree_user.present?
    #  @photo_votes = Blog::CelebrityPhotoVote.where(
    #    user_id: current_spree_user.id, celebrity_photo_id: @latest_photos.map(&:id)
    #  )
    #end

    @featured_posts = Blog::Post.featured

    @latest_posts = Blog::Category.limit(6).map(&:latest_post).compact
    if (posts_needed = 6 - @latest_posts.length) > 0
      @latest_posts += Blog::Post.offset(@featured_posts.to_a.size).limit(posts_needed).to_a
    end
  end

  def tweets
    @tweets ||= TweetsLoader.new.load
  end
  helper_method :tweets

  def instagram_posts
    @instagram_posts ||= InstagramPostsLoader.new.load
  end
  helper_method :instagram_posts

  private

  def generate_breadcrumbs
    @breadcrumbs = [[root_path, 'Home']]
  end

  class InstagramPostsLoader
    def load(options = {})
      posts = load_posts(options)
      posts.collect do |post_data|
        OpenStruct.new({
          image_url: extract_image_url(post_data['images']),
          url: post_data['link']
        })
      end
    end

    def load_posts(options)
      count = options[:count] || 5
      Instagram.user_recent_media(
        configatron.instagram.user_id,
        client_id: configatron.instagram.client_id,
        count: count
      )
    end

    def extract_image_url(images_data)
      return '_sample/instagram-pic.jpg' if images_data.blank?
      if images_data['standard_resolution']
        return images_data['standard_resolution']['url']
      elsif images_data['low_resolution']
        return images_data['low_resolution']['url']
      else
        return images_data['thumbnail']['url']
      end
    rescue
      '_sample/instagram-pic.jpg'
    end
  end

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
end
