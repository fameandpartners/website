module BlogHelper
  # this should be in decorator
  def post_description(post)
    if post.description.present?
      ActionView::Base.full_sanitizer.sanitize(post.description)
    else
      truncate(ActionView::Base.full_sanitizer.sanitize(post.body), length: 100, omission: '', separator: ' ')
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

  def post_path(post)
    return '#' if post.nil?
    #return blog_red_carpet_post_path(post.slug) if post.red_carpet?
    if (category = post.category).present?
      blog_post_by_category_url(category_slug: category.slug, post_slug: post.slug) 
    else
      blog_post_path(post_slug: post.slug)
    end
  end
end
