class AddBlogRoles < ActiveRecord::Migration
  def up
    moderator_role = Spree::Role.find_by_name('Blog Moderator')
    if moderator_role.blank?
      Spree::Role.create(name: 'Blog Moderator')
    end
    admin_role = Spree::Role.find_by_name('Blog Admin')
    if admin_role.blank?
      Spree::Role.create(name: 'Blog Admin')
    end
  end

  def down
    moderator_role = Spree::Role.find_by_name('Blog Moderator')
    moderator_role.delete if moderator_role.blank?
    admin_role = Spree::Role.find_by_name('Blog Admin')
    admin_role.delete if admin_role.blank?
  end
end
