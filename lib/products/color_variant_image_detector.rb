module Products
  module ColorVariantImageDetector
    module_function
    def cropped_images_for(color_variant)
      find_images = ->(matcher, item) do
        item.images
          .select { |i| i.attachment_file_name.downcase.include? matcher }
          .sort_by(&:position)
          .collect { |i| i.attachment.url(:large) }
      end

      cropped_images = find_images.call('crop', color_variant)

      if cropped_images.blank?
        cropped_images = find_images.call('front', color_variant)
      end
      cropped_images
    end
  end
end
