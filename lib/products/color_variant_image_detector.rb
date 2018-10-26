module Products
  module ColorVariantImageDetector
    module_function

    def cropped_images_for(color_variant)
      cropped_images = find_images(matcher: 'crop', color_variant: color_variant)

      if cropped_images.blank?
        cropped_images = find_images(matcher: 'front', color_variant: color_variant)
      end
      cropped_images
    end

    private def find_images(matcher:, color_variant:)
      color_variant.images
        .select { |i| i.attachment_file_name.downcase.include? matcher }
        .sort_by { |i| i.position.to_i } # Position can be nil, and should be compared as zero
    end
  end
end
