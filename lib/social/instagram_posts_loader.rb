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
