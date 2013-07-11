Spree::Role.class_eval do
  class << self
    def moderator_role
      where(name: 'Blog Moderator').first
    end
  end
end
