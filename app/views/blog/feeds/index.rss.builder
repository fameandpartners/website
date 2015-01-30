xml.instruct! :xml, version: 1.0
xml.rss version: 2.0 do
  def get_desc(post)
    return post.body unless post.primary_photo.present?
    return "<p> #{image_tag post.primary_photo.photo.url(:preview), width: 742, height: 355, alt: ''}</p><p>#{post.body}</p>"
  end
  
  xml.channel do
    xml.title 'The Fame Issue'
    xml.description 'Tracking Fashion, Celebrity, Style and Trends. Edited by the Stylists at Fame & Partners'
    xml.link blog_url

    @posts.each do |post|
      if post.red_carpet?
        url = blog_red_carpet_post_url(post_slug: post.slug)
      elsif post.simple?
        url = blog_post_by_category_url(category_slug: post.category.slug, post_slug: post.slug)
      end

      xml.item do
        xml.title post.title
        xml.description get_desc(post)
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link url
        xml.guid url
      end
    end
  end
end
