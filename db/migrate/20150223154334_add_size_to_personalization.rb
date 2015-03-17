class AddSizeToPersonalization < ActiveRecord::Migration
  def up
    add_column :line_item_personalizations, :size_id, :integer, after: :size

    update_existing_line_items
  end

  def down
    remove_column :line_item_personalizations, :size_id
  end

  private

    def update_existing_line_items
      all_sizes = Repositories::ProductSize.read_all

      LineItemPersonalization.all.each do |line_item|
        next if line_item.size.blank?
        size = all_sizes.detect{|s| s.value == line_item.size.to_i ||  s.presentation.to_s == line_item.size.to_s }

        line_item.update_column(:size_id, size.id) if size.present?

        true
      end
    end
end
