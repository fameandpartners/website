module ContentfulPagesHelper

  def contentful_get_editorial_tile_link(contents)
    # Check if we have a direct URL to link this item
    if contents[:tile_url].present?
      contents[:tile_url]
    # Check if we need to render PID info (under the editorial tile)
    elsif contents[:editorial_tile_pid].present?
      pid_item = contents[:editorial_tile_pid][0]
      split_pid = pid_item.split('-', 2)
      pid_info = @collection.products.select do |item|
        if item.fabric.present? && item.fabric.name.present?
          item.id == split_pid[0].to_i && item.fabric.name == split_pid[1]
        elsif item.color.present? && item.color.name.present?
          item.id == split_pid[0].to_i && item.color.name == split_pid[1]
        else
          nil
        end
      end

      if pid_info.present?
        if pid_info[0].fabric.present?
          collection_product_path(pid_info[0], color: pid_info[0].fabric.try(:name))
        else
          collection_product_path(pid_info[0], color: pid_info[0].color.try(:name))
        end
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
          if item.fabric.present? && item.fabric.name
            item.id == current_id.to_i && item.fabric.name == current_color
          elsif item.color.present? && item.color.name
            item.id == current_id.to_i && item.color.name == current_color
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
