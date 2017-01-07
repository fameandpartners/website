namespace :update do
  namespace :images do
    task :positions => :environment do
      Spree::Product.active.each do |product|
        next if product.images.blank?

        grouped = product.images.group_by(&:viewable)
        positions = grouped.values.first.map(&:position).sort_by(&:to_i)

        sorted = true

        positions.each_with_index do |position, index|
          if positions[index + 1].present?
            unless positions[index + 1] == position.next
              sorted = false
            end
          end
        end

        next if sorted

        viewable = product.images.first.viewable

        product.images.update_all(position: 0)

        groups = []

        groups << grouped.delete(viewable)
        groups += grouped.values

        groups.each do |group|
          group.sort_by!(&:attachment_file_name)

          if group.last.attachment_file_name.include?('Front')
            group.unshift(group.pop)
          end
        end

        groups.each do |group|
          start = product.images.maximum(:position) + 1

          group.each_with_index do |image, index|
            image.update_column(:position, start + index)
          end
        end
      end
    end
  end
end
