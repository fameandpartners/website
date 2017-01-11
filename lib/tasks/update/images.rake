namespace :update do
  namespace :images do
    task :positions => :environment do
      Spree::Product.active.each do |product|
        next if product.images.blank?

        grouped = product.images.group_by(&:viewable)
        positions = grouped.values.first.map(&:position).map(&:to_i).sort

        sorted = \
          positions.each_cons(2).all? { |position, next_position| position.next == next_position }

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
