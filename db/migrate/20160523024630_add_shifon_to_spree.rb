class AddShifonToSpree < ActiveRecord::Migration
  def up
    u = Spree::User.where(email: 'raymond.su@fameandpartners.com.cn').first
    if u.present?
      u.password = 'raymondsu'
      u.password_confirmation = 'raymondsu'
      u.save!
      u.spree_roles << Spree::Role.find_by_name('admin') if u.present?
    end
  end

  def down
    #NOOP
  end
end
