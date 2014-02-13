module BlogHelper
  # this should be in decorator
  def post_description(post)
    if post.description.present?
      post.description
    else
      truncate(post.body, length: 100, omission: '', separator: ' ')
    end
  end

  def post_photo_url(post)
    image = post.primary_photo
    image ||= post.post_photos.first

    if image.present?
      image.photo.url
    else
      # default image url
      Blog::PostPhoto.new.photo.url
    end
  end
end
