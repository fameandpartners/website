xml.instruct! :xml, version: 1.0
xml.rss version: 2.0 do
  xml.channel do
    xml.title 'Fame & Partners Formal Dresses Blog'
    xml.description 'Fame & Partners are a leading online website selling all types of dresses including formal, evening and prom dresses online.'
    xml.link blog_url

    @posts.each do |post|
      if post.red_carpet?
        url = blog_red_carpet_post_url(post.slug)
      elsif post.simple?
        url = blog_post_by_category_url(post.category.slug, post.slug)
      end

      xml.item do
        xml.title post.title
        xml.description post.body
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link url
        xml.guid url
      end
    end
  end
end
