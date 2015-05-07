Spree::Admin::BaseController.class_eval do
  prepend_before_filter do
    if spree_current_user.present?
      if !spree_current_user.has_spree_role?('admin') &&
        (spree_current_user.has_spree_role?("Blog Moderator") || spree_current_user.has_spree_role?("Blog Admin")) &&
        !(request.path =~ /\/admin\/blog/)
        redirect_to admin_blog_posts_path
      end
    end
  end

  skip_before_filter :check_site_version
end
