module PostHelper
  def admin_post_path post, form=:plural, resource=nil, prefix=nil
    if post.to_sym == :fashion_news && form.to_sym == :plural
      post = :index_news
    end
    prefix = "#{prefix}_" if prefix
    send("#{prefix}admin_blog_#{post.to_s.send("#{form}ize")}_path", resource)
  end
end