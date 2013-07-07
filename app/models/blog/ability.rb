class Blog::Ability
  include CanCan::Ability

    def initialize(user)
      user ||= Spree::User.new

      if user.has_spree_role?("Blog Moderator") || user.has_spree_role?("Blog Admin") ||
        user.has_spree_role?("admin")
        can :admin, Blog
        can [:edit, :index, :destroy, :create, :update, :new], Blog::Post
        can [:edit, :index, :destroy, :create, :update, :new], Blog::Celebrity
        can [:edit, :index, :destroy, :create, :update, :new, :assign_celebrity], Blog::CelebrityPhoto
        can [:edit, :index, :destroy, :create, :update, :new], Blog::PostPhoto
      end

      if user.has_spree_role?("Blog Admin") || user.has_spree_role?("admin")
        can :toggle_publish, Blog::Post
        can :toggle_featured, Blog::Celebrity
        can :manage,  Blog::Category
        can :manage,  Blog::PromoBanner
      end
    end
end
