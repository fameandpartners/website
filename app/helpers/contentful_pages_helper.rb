module ContentfulPagesHelper

  def contentful_get_editorial_tile_link(contents)
    # Check if we need to render PID info (under the editorial tile)
    if contents[:editorial_tile_pid].present?
      pid_item = contents[:editorial_tile_pid][0]
      split_pid = pid_item.split('-', 2)
      pid_info = @collection.products.select do |item|
        if item.color.present? && item.color.name.present?
          item.id == split_pid[0].to_i && item.color.name == split_pid[1]
        else
          nil
        end
      end

      if pid_info.present?
        collection_product_path(pid_info[0], color: pid_info[0].color.try(:name))
      end
    else
      if contents[:bottom_caption].present? && contents[:bottom_caption_url].present?
        contents[:bottom_caption_url]
      end
    end
  end

  def contentful_get_products_array_via_pids_array(pids_array)
    products = []

    if pids_array.present?

      pids_array.each do |pid|
        split_pid = pid.split('-', 2)
        current_id = split_pid[0].to_i
        current_color = split_pid[1]

        present_product = @collection.products.select do |item|
          if item.color.present? && item.color.name.present?
            item.id == current_id && item.color.name == current_color
          else
            nil
          end
        end

        if present_product.present?
          products.push(present_product[0])
        end
      end
    end

    # Get array of products info
    products

  end

end
