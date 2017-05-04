class UpdatePeachAndCoralColors < ActiveRecord::Migration
  def up
    coral = Spree::OptionValue.find_by_name('coral')
    peach = Spree::OptionValue.find_by_name('peach')

    coral.update_attribute(:value, '#FD9A92')
    peach.update_attribute(:value, '#F7C6B0')
  end
end
