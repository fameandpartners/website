module ContentfulHelper
  ## CMS

  ## to-do: Refactor!
  ##  when: Before adding next modules

  def get_contentful_parent_container
    if (params['developer'] == 'preview')
      Rails.cache.delete('contentful-cms-cache-key')
      @contentful_client ||= Contentful::Client.new(
        api_url: configatron.contentful.preview_api_url,
        access_token: configatron.contentful.preview_token,
        space: configatron.contentful.space_id,
        dynamic_entries: :auto,
        raise_errors: true
      )
      create_home_page_container_from_contentful(@contentful_client.entries(content_type: 'homePageContainer')[0])
    else
      Rails.cache.fetch('contentful-cms-cache-key') do
        @contentful_client ||= Contentful::Client.new(
          access_token: configatron.contentful.access_token,
          space: configatron.contentful.space_id,
          dynamic_entries: :auto,
          raise_errors: true
        )
        create_home_page_container_from_contentful(@contentful_client.entries(content_type: 'homePageContainer')[0])
      end
    end
  end

  def create_home_page_container_from_contentful(parent_container)

    hero_tiles = parent_container.hero_tiles_container.map do |item|

      # Check Optional Fields
      heading = (item.respond_to? :heading) ? item.heading : nil
      mobile_text = (item.respond_to? :mobile_text) ? item.mobile_text : nil
      sub_heading = (item.respond_to? :sub_heading) ? item.sub_heading : nil
      cta = (item.respond_to? :cta_button_text) ? item.cta_button_text : nil

      {
        heading: heading,
        sub_heading: sub_heading,
        mobile_text: mobile_text,
        image: item.image.url,
        mobile_image: item.mobile_image.url,
        link: item.path_link,
        text_align: item.text_alignment,
        text_position: item.text_position,
        text_color: item.text_color,
        text_size: item.text_size,
        text_padding: item.text_padding,
        cta_button_text: cta,
        description: item.description,
      }
    end

    second_hero = {
      image: parent_container.secondary_header_container.secondary_header_image.url,
      mobile_image: parent_container.secondary_header_container.secondary_header_mobile_image.url,
      path_link: parent_container.secondary_header_container.secondary_header_link
    }

    category_tiles = parent_container.category_tiles_container.map do |item|
      {
        link: item.link,
        title: item.title_overlay,
        image: item.image.image_url
      }
    end

    ig_tiles = parent_container.instagram_thumbnails_container.map do |item|
      {
        path_link: item.path_link,
        handle: item.handle,
        image: item.image.image_url
      }
    end

    @main_container = {
      hero_tiles: hero_tiles,
      secondary_header: second_hero,
      category_tiles: category_tiles,
      instagram_tiles: ig_tiles
    }
  end

  # LANDING PAGE SPECIFIC
  ## TO-DO: NEEDS REFACTORING WITH ABOVE!!!

  def get_contentful_lp_parent_container
    # if (params['developer'] == 'preview')
    #   puts '*'*60
    #   puts 'In PREVIEW MODE - Fetching unpublished Contentful data...'
    #   puts '*'*60
    #   Rails.cache.delete('contentful-cms-lp-cache-key')
    #   @contentful_client ||= Contentful::Client.new(
    #     api_url: ENV['CONTENTFUL_PREVIEW_API_URL'],
    #     access_token: ENV['CONTENTFUL_SANDBOX_PREVIEW_TOKEN'],
    #     space: ENV['CONTENTFUL_SANDBOX_SPACE_ID'],
    #     dynamic_entries: :auto,
    #     raise_errors: true
    #   )
    #   create_landing_page_container(@contentful_client.entries(content_type: 'landingPageContainer')[0])
    # else
    #   puts '-'*60
    #   puts 'In PRODUCTION Mode - Loading cached Contentful data...'
    #   puts '-'*60
    #   Rails.cache.fetch('contentful-cms-lp-cache-key') do
        puts '/'*60
        puts 'NO CACHE - Fetching latest published Contentful data...'
        puts '/'*60
        @contentful_client ||= Contentful::Client.new(
          access_token: ENV['CONTENTFUL_SANDBOX_ACCESS_TOKEN'],
          space: ENV['CONTENTFUL_SANDBOX_SPACE_ID'],
          dynamic_entries: :auto,
          raise_errors: true
        )
        create_landing_page_container(@contentful_client.entries(content_type: 'landingPageContainer')[0])
      # end
    # end
  end

  def create_landing_page_container(parent_container)

    row_tiles = parent_container.rows_container.map do |item|
      {
        id: item.content_type.id,
        # title: item.row_heading,
        # contents: item.contents
      }
    end

    # hero_tiles = parent_container.hero_tiles_container.map do |item|

    #   # Check Optional Fields
    #   heading = (item.respond_to? :heading) ? item.heading : nil
    #   mobile_text = (item.respond_to? :mobile_text) ? item.mobile_text : nil
    #   sub_heading = (item.respond_to? :sub_heading) ? item.sub_heading : nil
    #   cta = (item.respond_to? :cta_button_text) ? item.cta_button_text : nil

    #   {
    #     heading: heading,
    #     sub_heading: sub_heading,
    #     mobile_text: mobile_text,
    #     image: item.image.url,
    #     mobile_image: item.mobile_image.url,
    #     link: item.path_link,
    #     text_align: item.text_alignment,
    #     text_position: item.text_position,
    #     text_color: item.text_color,
    #     text_size: item.text_size,
    #     cta_button_text: cta,
    #     description: item.description,
    #   }
    # end

    # second_hero = {
    #   image: parent_container.secondary_header_container.secondary_header_image.url,
    #   mobile_image: parent_container.secondary_header_container.secondary_header_mobile_image.url,
    #   path_link: parent_container.secondary_header_container.secondary_header_link
    # }

    # category_tiles = parent_container.category_tiles_container.map do |item|
    #   {
    #     link: item.link,
    #     title: item.title_overlay,
    #     image: item.image.image_url
    #   }
    # end

    # ig_tiles = parent_container.instagram_thumbnails_container.map do |item|
    #   {
    #     path_link: item.path_link,
    #     handle: item.handle,
    #     image: item.image.image_url
    #   }
    # end

    # @main_container = {
    #   hero_tiles: hero_tiles,
    #   secondary_header: second_hero,
    #   category_tiles: category_tiles,
    #   instagram_tiles: ig_tiles
    # }

    binding.pry

    @landing_page_container = {
      # to-do: title
      # to-do: path
      # to-do: header

      rows: row_tiles
    }
  end


end
