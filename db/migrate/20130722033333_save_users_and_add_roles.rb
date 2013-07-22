class SaveUsersAndAddRoles < ActiveRecord::Migration
  def up
    Spree::User.find_in_batches(batch_size: 200) do |batch|
      batch.reject(&:blank?).each do |user|
        user.save
      end
    end

    moderator_role = Spree::Role.find_by_name('Blog Moderator')
    if moderator_role.blank?
      Spree::Role.create(name: 'Blog Moderator')
    end
    admin_role = Spree::Role.find_by_name('Blog Admin')
    if admin_role.blank?
      Spree::Role.create(name: 'Blog Admin')
    end
  end
end
