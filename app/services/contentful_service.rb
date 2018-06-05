module Contentful
  class Service
    ## CMS
    def self.get_all_contentful_containers(preview = false)

      if preview
        create_contentful_preview_lp_client()
        create_contentful_preview_homepage_client()
      else
        create_contentful_lp_client()
        create_contentful_homepage_client()
      end

      landing_pages = get_all_landing_page_containers()
      home_page = get_all_homepage_containers()

      landing_pages.merge(home_page)
    end

    private

    def self.create_home_page_container_from_contentful(parent_container)

      hero_tiles = parent_container.hero_tiles_container.map do |item|

        # Check Optional Fields
        heading = (item.respond_to? :heading) ? item.heading : nil
        sub_heading = (item.respond_to? :sub_heading) ? item.sub_heading : nil
        heading_mobile = (item.respond_to? :mobile_text) ? item.mobile_text : nil
        subheading_mobile = (item.respond_to? :subheading_mobile) ? item.subheading_mobile : nil
        mobile_text = (item.respond_to? :mobile_text) ? item.mobile_text : nil
        cta_button_text = (item.respond_to? :cta_button_text) ? item.cta_button_text : nil
        cta_button_background_color = (item.respond_to? :cta_button_background_color) ? item.cta_button_background_color : 'transparent'
        cta_button_text_color = (item.respond_to? :cta_button_text_color) ? item.cta_button_text_color : '#fff'
        cta_button_border_color = (item.respond_to? :cta_button_border_color) ? item.cta_button_border_color : '#fff'
        image = (item.respond_to? :image) ? item.image.url : nil
        mobile_image = (item.respond_to? :mobile_image) ? item.mobile_image.url : image
        video = (item.respond_to? :video_desktop) ? item.video_desktop.url : nil
        mobile_video = (item.respond_to? :video_mobile) ? item.video_mobile.url : video
        path_link = (item.respond_to? :path_link) ? item.path_link : nil
        text_vertical_position = (item.respond_to? :vertical_position) ? item.vertical_position.downcase : nil
        text_vertical_position_mobile = (item.respond_to? :vertical_position_mobile) ? item.vertical_position_mobile.downcase : nil
        text_position = (item.respond_to? :text_position) ? item.text_position.downcase : nil
        text_color = (item.respond_to? :text_color) ? item.text_color.downcase : nil
        text_size = (item.respond_to? :text_size) ? item.text_size : nil
        extra_padding_top = (item.respond_to? :extra_padding_top) ? item.extra_padding_top : '0px'
        extra_padding_top_mobile = (item.respond_to? :extra_padding_top_mobile) ? item.extra_padding_top_mobile : '0px'

        hero_tile_site_version_array = (item.respond_to? :hero_tile_site_version) ? item.hero_tile_site_version.sort.join(',').downcase : nil

        if hero_tile_site_version_array == "au" || hero_tile_site_version_array == "us"
          hero_tile_site_version = hero_tile_site_version_array
        else
          hero_tile_site_version = "all"
        end

        {
          heading: heading,
          sub_heading: sub_heading,
          heading_mobile: heading_mobile,
          subheading_mobile: subheading_mobile,
          image: image,
          mobile_image: mobile_image,
          video: video,
          mobile_video: mobile_video,
          link: path_link,
          text_vertical_position: text_vertical_position,
          text_vertical_position_mobile: text_vertical_position_mobile,
          text_position: text_position,
          text_color: text_color,
          text_size: text_size,
          extra_padding_top: extra_padding_top,
          extra_padding_top_mobile: extra_padding_top_mobile,
          cta_button_text: cta_button_text,
          cta_button_background_color: cta_button_background_color,
          cta_button_text_color: cta_button_text_color,
          cta_button_border_color: cta_button_border_color,
          hero_tile_site_version: hero_tile_site_version
        }
      end

      secondary_hero_tiles = parent_container.secondary_header_container.map do |item|

        desktop_image = (item.respond_to? :secondary_header_image) ? item.secondary_header_image.url : nil
        mobile_image = (item.respond_to? :secondary_header_mobile_image) ? item.secondary_header_mobile_image.url : nil
        path_link = (item.respond_to? :secondary_header_link) ? item.secondary_header_link : nil

        {
          image: desktop_image,
          mobile_image: mobile_image,
          path_link: path_link
        }
      end

      category_tiles = parent_container.category_tiles_container.map do |item|

        # Edits CTA
        tile_cta_link = (item.respond_to? :link) ? item.link : nil
        tile_cta_image_url = (item.image.respond_to? :image_url) ? item.image.image_url : nil
        tile_cta_array = (item.respond_to? :title_overlay) ? item.title_overlay.split('||') : nil

        if tile_cta_array.nil?
          tile_cta_first = nil
          tile_cta_last = nil
        else
          if tile_cta_array.size < 2
            tile_cta_first = nil
            tile_cta_last = tile_cta_array[0]
          else
            tile_cta_first = tile_cta_array[0]
            tile_cta_last = tile_cta_array[1]
          end
        end

        {
          link: tile_cta_link,
          tile_cta_first: tile_cta_first,
          tile_cta_last: tile_cta_last,
          image: tile_cta_image_url
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
        secondary_header: secondary_hero_tiles,
        category_tiles: category_tiles,
        instagram_tiles: ig_tiles
      }

    end

    def self.create_contentful_lp_client
      @contentful_client = Contentful::Client.new(
        access_token: ENV['CONTENTFUL_SANDBOX_ACCESS_TOKEN'],
        space: ENV['CONTENTFUL_SANDBOX_SPACE_ID'],
        dynamic_entries: :auto,
        raise_errors: true
      )
    end

    def self.create_contentful_homepage_client
      @contentful_client_homepage = Contentful::Client.new(
        access_token: configatron.contentful.access_token,
        space: configatron.contentful.space_id,
        dynamic_entries: :auto,
        raise_errors: true
      )
    end

    def self.create_contentful_preview_lp_client
      @contentful_client = Contentful::Client.new(
        api_url: configatron.contentful.preview_api_url,
        access_token: ENV['CONTENTFUL_SANDBOX_PREVIEW_TOKEN'],
        space: ENV['CONTENTFUL_SANDBOX_SPACE_ID'],
        dynamic_entries: :auto,
        raise_errors: true
      )
    end

    def self.create_contentful_preview_homepage_client
      @contentful_client_homepage = Contentful::Client.new(
        api_url: configatron.contentful.preview_api_url,
        access_token: configatron.contentful.preview_token,
        space: configatron.contentful.space_id,
        dynamic_entries: :auto,
        raise_errors: true
      )
    end

    def self.get_all_landing_page_containers
      relative_url_array = @contentful_client.entries(content_type: 'landingPageContainer').map do |lp|
        lp.relative_url
      end

      Hash[relative_url_array.map { |url| [url, create_landing_page_container(@contentful_client.entries(content_type: 'landingPageContainer', 'fields.relativeUrl[match]' => url)[0]) ]}]
    end

    def self.get_all_homepage_containers

      homepage = create_home_page_container_from_contentful(@contentful_client_homepage.entries(content_type: 'homePageContainer')[0])

      { "/" => homepage }
    end

    def self.jsonify_large_lp_container(large_container)
      id = large_container.id

      fetched_lg_container = @contentful_client.entries('sys.id' => id)[0]
      desktop_image = (fetched_lg_container.respond_to? :image) ? fetched_lg_container.image.url : nil
      mobile_image = (fetched_lg_container.respond_to? :mobile_image) ? fetched_lg_container.mobile_image.url : desktop_image
      desktop_video = (fetched_lg_container.respond_to? :video_desktop) ? fetched_lg_container.video_desktop.url : nil
      mobile_video = (fetched_lg_container.respond_to? :video_mobile) ? fetched_lg_container.video_mobile.url : nil

      if (fetched_lg_container.content_type.id == 'ITEM--lg')
        editorial_tile_pid = (fetched_lg_container.respond_to? :editorial_tile_pid) ? fetched_lg_container.editorial_tile_pid : nil
        overlay_pids = (fetched_lg_container.respond_to? :overlay_pids) ? fetched_lg_container.overlay_pids : nil
        image_caption = (fetched_lg_container.respond_to? :image_caption) ? fetched_lg_container.image_caption : nil
        image_caption_color = (fetched_lg_container.respond_to? :image_caption_color) ? fetched_lg_container.image_caption_color : 'white'
        image_caption_url = (fetched_lg_container.respond_to? :image_caption_url) ? fetched_lg_container.image_caption_url : nil
        image_caption_link_target = (fetched_lg_container.respond_to? :image_caption_link_target) ? fetched_lg_container.image_caption_link_target : nil
        image_caption_link_target = image_caption_link_target ? '_blank' : '_self'
        bottom_caption = (fetched_lg_container.respond_to? :bottom_caption) ? fetched_lg_container.bottom_caption : nil
        bottom_caption_url = (fetched_lg_container.respond_to? :bottom_caption_url) ? fetched_lg_container.bottom_caption_url : nil

        {
          image: desktop_image,
          mobile_image: mobile_image,
          video: desktop_video,
          mobile_video: mobile_video,
          editorial_tile_pid: editorial_tile_pid,
          overlay_pids: overlay_pids,
          image_caption: image_caption,
          image_caption_color: image_caption_color,
          image_caption_url: image_caption_url,
          image_caption_link_target: image_caption_link_target,
          bottom_caption: bottom_caption,
          bottom_caption_url: bottom_caption_url
        }
      elsif (fetched_lg_container.content_type.id == 'ITEM--lg__carousel')
        tile_url = (fetched_lg_container.respond_to? :tile_url) ? fetched_lg_container.tile_url : nil
        tile_link_target = (fetched_lg_container.respond_to? :tile_link_target) ? fetched_lg_container.tile_link_target : nil
        tile_link_target = tile_link_target ? '_blank' : '_self'

        {
          image: desktop_image,
          mobile_image: mobile_image,
          tile_url: tile_url,
          tile_link_target: tile_link_target,
          video: desktop_video,
          mobile_video: mobile_video,
          bottom_caption: bottom_caption,
          bottom_caption_url: bottom_caption_url
        }
      elsif (fetched_lg_container.content_type.id == 'ITEM--category-block')
        tile_url = (fetched_lg_container.respond_to? :tile_url) ? fetched_lg_container.tile_url : nil

        {
          image: desktop_image,
          mobile_image: mobile_image,
          tile_url: tile_url,
          video: desktop_video,
          mobile_video: mobile_video
        }
      elsif (fetched_lg_container.content_type.id == 'ITEM--lg__cta-button')
        relative_url = (fetched_lg_container.respond_to? :relative_url) ? fetched_lg_container.relative_url : nil
        background_color = (fetched_lg_container.respond_to? :background_color) ? fetched_lg_container.background_color : 'transparent'
        text_color = (fetched_lg_container.respond_to? :text_color) ? fetched_lg_container.text_color : '#000'
        border_color = (fetched_lg_container.respond_to? :border_color) ? fetched_lg_container.border_color : 'transparent'
        button_label = (fetched_lg_container.respond_to? :button_label) ? fetched_lg_container.button_label : nil

        {
          relative_url: relative_url,
          background_color: background_color,
          text_color: text_color,
          border_color: border_color,
          button_label: button_label
        }
      elsif (fetched_lg_container.content_type.id == 'ITEM--editorial-tile-copy-cta-button-overlay')
        heading = (fetched_lg_container.respond_to? :heading) ? fetched_lg_container.heading : nil
        sub_heading = (fetched_lg_container.respond_to? :sub_heading) ? fetched_lg_container.sub_heading : nil
        heading_mobile = (fetched_lg_container.respond_to? :mobile_text) ? fetched_lg_container.mobile_text : nil
        subheading_mobile = (fetched_lg_container.respond_to? :subheading_mobile) ? fetched_lg_container.subheading_mobile : nil
        mobile_text = (fetched_lg_container.respond_to? :mobile_text) ? fetched_lg_container.mobile_text : nil
        cta_button_text = (fetched_lg_container.respond_to? :cta_button_text) ? fetched_lg_container.cta_button_text : nil
        cta_button_background_color = (fetched_lg_container.respond_to? :cta_button_background_color) ? fetched_lg_container.cta_button_background_color : 'transparent'
        cta_button_text_color = (fetched_lg_container.respond_to? :cta_button_text_color) ? fetched_lg_container.cta_button_text_color : '#fff'
        cta_button_border_color = (fetched_lg_container.respond_to? :cta_button_border_color) ? fetched_lg_container.cta_button_border_color : '#fff'
        image = (fetched_lg_container.respond_to? :image) ? fetched_lg_container.image.url : nil
        mobile_image = (fetched_lg_container.respond_to? :mobile_image) ? fetched_lg_container.mobile_image.url : image
        video = (fetched_lg_container.respond_to? :video_desktop) ? fetched_lg_container.video_desktop.url : nil
        mobile_video = (fetched_lg_container.respond_to? :video_mobile) ? fetched_lg_container.video_mobile.url : video
        path_link = (fetched_lg_container.respond_to? :path_link) ? fetched_lg_container.path_link : nil
        text_vertical_position = (fetched_lg_container.respond_to? :vertical_position) ? fetched_lg_container.vertical_position.downcase : nil
        text_vertical_position_mobile = (fetched_lg_container.respond_to? :vertical_position_mobile) ? fetched_lg_container.vertical_position_mobile.downcase : nil
        text_position = (fetched_lg_container.respond_to? :text_position) ? fetched_lg_container.text_position.downcase : nil
        text_color = (fetched_lg_container.respond_to? :text_color) ? fetched_lg_container.text_color.downcase : nil
        text_size = (fetched_lg_container.respond_to? :text_size) ? fetched_lg_container.text_size : nil
        extra_padding_top = (fetched_lg_container.respond_to? :extra_padding_top) ? fetched_lg_container.extra_padding_top : '0px'
        extra_padding_top_mobile = (fetched_lg_container.respond_to? :extra_padding_top_mobile) ? fetched_lg_container.extra_padding_top_mobile : '0px'

        hero_tile_site_version_array = (fetched_lg_container.respond_to? :hero_tile_site_version) ? fetched_lg_container.hero_tile_site_version.sort.join(',').downcase : nil

        if hero_tile_site_version_array == "au" || hero_tile_site_version_array == "us"
          hero_tile_site_version = hero_tile_site_version_array
        else
          hero_tile_site_version = "all"
        end

        {
          heading: heading,
          sub_heading: sub_heading,
          heading_mobile: heading_mobile,
          subheading_mobile: subheading_mobile,
          image: image,
          mobile_image: mobile_image,
          video: video,
          mobile_video: mobile_video,
          tile_url: path_link,
          text_vertical_position: text_vertical_position,
          text_vertical_position_mobile: text_vertical_position_mobile,
          text_position: text_position,
          text_color: text_color,
          text_size: text_size,
          extra_padding_top: extra_padding_top,
          extra_padding_top_mobile: extra_padding_top_mobile,
          cta_button_text: cta_button_text,
          cta_button_background_color: cta_button_background_color,
          cta_button_text_color: cta_button_text_color,
          cta_button_border_color: cta_button_border_color,
          hero_tile_site_version: hero_tile_site_version
        }
      elsif (fetched_lg_container.content_type.id == 'ITEM--editorial-tile-copy-pid')
        editorial_tile_pid = (fetched_lg_container.respond_to? :editorial_tile_pid) ? fetched_lg_container.editorial_tile_pid : nil
        bottom_caption = (fetched_lg_container.respond_to? :bottom_caption) ? fetched_lg_container.bottom_caption : nil
        text = (fetched_lg_container.respond_to? :text) ? fetched_lg_container.text : nil
        text_alignment = (fetched_lg_container.respond_to? :text_alignment) ? fetched_lg_container.text_alignment : nil

        {
          image: desktop_image,
          mobile_image: mobile_image,
          video: desktop_video,
          mobile_video: mobile_video,
          editorial_tile_pid: editorial_tile_pid,
          bottom_caption: bottom_caption,
          text: text,
          text_alignment: text_alignment
        }
      elsif (fetched_lg_container.content_type.id == 'ITEM--collapsible-entry')
        title = (fetched_lg_container.respond_to? :title) ? fetched_lg_container.title : nil
        text = (fetched_lg_container.respond_to? :text) ? fetched_lg_container.text : nil
        {
          title: title,
          text: text
        }
      end
    end

    def self.jsonify_medium_lp_container(medium_container)
      id = medium_container.id

      fetched_md_container = @contentful_client.entries('sys.id' => id)[0]

      if (fetched_md_container.content_type.id == 'ITEM--md-text')
        text_desktop = (fetched_md_container.respond_to? :content) ? fetched_md_container.content.split("\n") : nil
        text_mobile = (fetched_md_container.respond_to? :content_mobile) ? fetched_md_container.content_mobile.split("\n") : text_desktop
        text_size = (fetched_md_container.respond_to? :text_size) ? fetched_md_container.text_size : nil

        {
          id: 'ITEM--md-text',
          text: text_desktop,
          text_mobile: text_mobile,
          text_size: text_size
        }
      elsif (fetched_md_container.content_type.id == 'ITEM--md-text--heading-with-custom-color')
        text_desktop = (fetched_md_container.respond_to? :content) ? fetched_md_container.content.split("\n") : nil
        text_mobile = (fetched_md_container.respond_to? :content_mobile) ? fetched_md_container.content_mobile.split("\n") : text_desktop
        text_size = (fetched_md_container.respond_to? :text_size) ? "--#{fetched_md_container.text_size}" : nil
        copy_block_heading = (fetched_md_container.respond_to? :copy_block_heading) ? fetched_md_container.copy_block_heading : nil
        copy_block_heading_color = (fetched_md_container.respond_to? :copy_block_heading_color) ? fetched_md_container.copy_block_heading_color : '#000'

        {
          id: 'ITEM--md-text--heading-with-custom-color',
          text: text_desktop,
          text_mobile: text_mobile,
          text_size: text_size,
          copy_block_heading: copy_block_heading,
          copy_block_heading_color: copy_block_heading_color
        }
      else
        # 'ITEM--md-email'
      end
    end

    def self.jsonify_small_lp_container(small_container)
      id = small_container.id

      fetched_sm_container = @contentful_client.entries('sys.id' => id)[0]

      if (fetched_sm_container.content_type.id == 'ITEM--sm-cta-tile')
        tile_cta_image_url = (fetched_sm_container.respond_to? :tile_cta_image) ? fetched_sm_container.tile_cta_image.url : nil
        tile_cta_link = (fetched_sm_container.respond_to? :tile_cta_link_url) ? fetched_sm_container.tile_cta_link_url : :best_sellers
        tile_cta_link_target = (fetched_sm_container.respond_to? :tile_cta_link_target) ? fetched_sm_container.tile_cta_link_target : nil
        tile_cta_link_target = tile_cta_link_target ? "_blank" : "_self"
        tile_cta_heading = (fetched_sm_container.respond_to? :tile_heading_text_desktop) ? fetched_sm_container.tile_heading_text_desktop : nil
        tile_cta_heading_mobile = (fetched_sm_container.respond_to? :tile_heading_text_mobile) ? fetched_sm_container.tile_heading_text_mobile : heading
        tile_cta_text = (fetched_sm_container.respond_to? :tile_content_desktop) ? fetched_sm_container.tile_content_desktop.gsub("\n", "<br />") : nil
        tile_cta_text_mobile = (fetched_sm_container.respond_to? :tile_content_mobile) ? fetched_sm_container.tile_content_mobile.gsub("\n", "<br />") : text
        tile_cta_link_text = (fetched_sm_container.respond_to? :tile_cta_text_desktop) ? fetched_sm_container.tile_cta_text_desktop : 'Find out more'
        tile_cta_link_text_mobile = (fetched_sm_container.respond_to? :tile_cta_text_mobile) ? fetched_sm_container.tile_cta_text_mobile : tile_cta_text

        {
          id: 'ITEM--sm-cta-tile',
          tile_cta_image_url: tile_cta_image_url,
          tile_cta_link: tile_cta_link,
          tile_cta_link_target: tile_cta_link_target,
          tile_cta_heading: tile_cta_heading,
          tile_cta_heading_mobile: tile_cta_heading_mobile,
          tile_cta_text: tile_cta_text,
          tile_cta_text_mobile: tile_cta_text_mobile,
          tile_cta_link_text: tile_cta_link_text,
          tile_cta_link_text_mobile: tile_cta_link_text_mobile
        }
      end
    end

    def self.jsonify_header_container(main_header_container)
      if (main_header_container.content_type.id == 'HEADER--xl-text')
        header_container = (main_header_container.respond_to? :header_container) ? jsonify_medium_lp_container(main_header_container.header_container) : nil

        {
          id: main_header_container.content_type.id,
          header_container: header_container
        }
      elsif (main_header_container.content_type.id == 'HEADER--lg__md-sm2')
        header_lg_item = (main_header_container.respond_to? :editorial_container) ? jsonify_large_lp_container(main_header_container.editorial_container) : nil
        header_sm_items = (main_header_container.respond_to? :pids) ? main_header_container.pids : nil
        header_text = (main_header_container.respond_to? :header_text) ? main_header_container.header_text : nil
        header_text_mobile = (main_header_container.respond_to? :header_text_mobile) ? main_header_container.header_text_mobile : header_text
        email_text = (main_header_container.respond_to? :email_capture_text) ? main_header_container.email_capture_text : nil
        full_width_content = (main_header_container.respond_to? :full_width_content) ? 'u-forced-full-width-wrapper' : nil

        {
          id: main_header_container.content_type.id,
          header_lg_item: header_lg_item,
          header_text: header_text,
          header_text_mobile: header_text_mobile,
          email_capture: main_header_container.show_email_capture,
          email_text: email_text,
          header_sm_items: header_sm_items,
          full_width_content: full_width_content
        }
      elsif (main_header_container.content_type.id == 'HEADER--xl-editorial')
        overlay_pids = (main_header_container.respond_to? :overlay_pids) ? main_header_container.overlay_pids : nil
        desktop_image = (main_header_container.respond_to? :image) ? main_header_container.image.url : nil
        mobile_image = (main_header_container.respond_to? :mobile_image) ? main_header_container.mobile_image.url : desktop_image
        desktop_video = (main_header_container.respond_to? :video_desktop) ? main_header_container.video_desktop.url : nil
        mobile_video = (main_header_container.respond_to? :video_mobile) ? main_header_container.video_mobile.url : nil
        tile_url = (main_header_container.respond_to? :tile_url) ? main_header_container.tile_url : nil
        live_text = (main_header_container.respond_to? :live_text) ? main_header_container.live_text : nil
        live_text_color = (main_header_container.respond_to? :live_text_color) ? main_header_container.live_text_color : '#fff'
        tile_crop_edges_on_resize = (main_header_container.respond_to? :tile_crop_edges_on_resize) ? main_header_container.tile_crop_edges_on_resize.sort.join(',').downcase : nil
        full_width_content = (main_header_container.respond_to? :full_width_content) ? main_header_container.full_width_content.sort.join(',').downcase : nil

        if full_width_content == 'desktop,mobile'
          full_width_content_class = 'u-forced-full-width-wrapper u-forced-full-width-wrapper--mobile'
        elsif full_width_content == 'mobile'
          full_width_content_class = 'u-forced-full-width-wrapper--mobile'
        elsif full_width_content == 'desktop'
          full_width_content_class = 'u-forced-full-width-wrapper'
        end

        {
          id: main_header_container.content_type.id,
          full_width_content_class: full_width_content_class,
          image: desktop_image,
          mobile_image: mobile_image,
          video: desktop_video,
          mobile_video: mobile_video,
          tile_url: tile_url,
          overlay_pids: overlay_pids,
          live_text: live_text,
          live_text_color: live_text_color,
          tile_crop_edges_on_resize: tile_crop_edges_on_resize
        }
      elsif (main_header_container.content_type.id == 'HEADER--xl-editorial-carousel')
        carousel_items = (main_header_container.respond_to? :carousel_tiles) ? map_editorials(main_header_container.carousel_tiles) : nil
        tile_crop_edges_on_resize = (main_header_container.respond_to? :tile_crop_edges_on_resize) ? main_header_container.tile_crop_edges_on_resize.sort.join(',').downcase : nil
        full_width_content = (main_header_container.respond_to? :full_width_content) ? main_header_container.full_width_content.sort.join(',').downcase : nil

        if full_width_content == 'desktop,mobile'
          full_width_content_class = 'u-forced-full-width-wrapper u-forced-full-width-wrapper--mobile'
        elsif full_width_content == 'mobile'
          full_width_content_class = 'u-forced-full-width-wrapper--mobile'
        elsif full_width_content == 'desktop'
          full_width_content_class = 'u-forced-full-width-wrapper'
        end

        {
          id: main_header_container.content_type.id,
          full_width_content_class: full_width_content_class,
          carousel_items: carousel_items,
          tile_crop_edges_on_resize: tile_crop_edges_on_resize
        }
      elsif (main_header_container.content_type.id == 'HEADER--editorial-tile-overlay')
        carousel_items = (main_header_container.respond_to? :carousel_tiles) ? map_editorials(main_header_container.carousel_tiles) : nil
        tile_crop_edges_on_resize = (main_header_container.respond_to? :tile_crop_edges_on_resize) ? main_header_container.tile_crop_edges_on_resize.sort.join(',').downcase : nil

        {
          id: main_header_container.content_type.id,
          carousel_items: carousel_items,
          tile_crop_edges_on_resize: tile_crop_edges_on_resize
        }
      end
    end

    def self.map_editorials(arr)
      arr.map do |item|
        jsonify_large_lp_container(item)
      end
    end

    def self.create_landing_page_container(parent_container)

      main_header_tile = jsonify_header_container(parent_container.header)

      row_tiles = parent_container.rows_container.map do |item|
        item_id = item.content_type.id
        item_name = (item.respond_to? :title) ? item.title : nil
        lg_item = (item.respond_to? :editorial_container) ? jsonify_large_lp_container(item.editorial_container) : nil
        lg_items = (item.respond_to? :editorials_container) ? map_editorials(item.editorials_container) : nil
        md_item = (item.respond_to? :header_container) ? jsonify_medium_lp_container(item.header_container) : nil
        sm_items = (item.respond_to? :pids) ? item.pids : nil
        content_tiles = (item.respond_to? :content_tiles) ? map_editorials(item.content_tiles) : nil
        email_text = (item.respond_to? :email_header_text) ? item.email_header_text : nil
        button_label = (item.respond_to? :button_label) ? item.button_label : nil
        relative_url = (item.respond_to? :relative_url) ? item.relative_url : nil
        floating_email_scroll_percentage = (item.respond_to? :floating_email_scroll_percentage) ? item.floating_email_scroll_percentage : nil

        # CTA Tiles
        tile_cta = (item.respond_to? :tile_cta_container) ? jsonify_small_lp_container(item.tile_cta_container) : nil
        tile_cta_position = (item.respond_to? :tile_cta_position) ? item.tile_cta_position : 4
        tile_cta_alignment = (item.respond_to? :tile_cta_alignment) ? item.tile_cta_alignment : 'left'

        # Hero tiles content
        overlay_pids = (item.respond_to? :overlay_pids) ? item.overlay_pids : nil
        desktop_image = (item.respond_to? :image) ? item.image.url : nil
        mobile_image = (item.respond_to? :mobile_image) ? item.mobile_image.url : desktop_image
        full_width_content = (item.respond_to? :full_width_content) ? item.full_width_content.sort.join(',').downcase : nil
        desktop_video = (item.respond_to? :video_desktop) ? item.video_desktop.url : nil
        mobile_video = (item.respond_to? :video_mobile) ? item.video_mobile.url : nil
        tile_url = (item.respond_to? :tile_url) ? item.tile_url : nil

        if full_width_content == 'desktop,mobile'
          full_width_content_class = 'u-forced-full-width-wrapper u-forced-full-width-wrapper--mobile'
        elsif full_width_content == 'mobile'
          full_width_content_class = 'u-forced-full-width-wrapper--mobile'
        elsif full_width_content == 'desktop'
          full_width_content_class = 'u-forced-full-width-wrapper'
        end

        # Text alignment
        text_alignment_desktop = (item.respond_to? :text_alignment) ? item.text_alignment.downcase : nil
        text_alignment_mobile = (item.respond_to? :text_alignment_mobile) ? item.text_alignment_mobile.downcase : nil

        if text_alignment_desktop == 'left'
          text_alignment_desktop_class = 'u-text-align-desktop--left'
        elsif text_alignment_desktop == 'right'
          text_alignment_desktop_class = 'u-text-align-desktop--right'
        else
          text_alignment_desktop_class = 'u-text-align-desktop--center'
        end

        if text_alignment_mobile == 'left'
          text_alignment_mobile_class = 'u-text-align-mobile--left'
        elsif text_alignment_mobile == 'right'
          text_alignment_mobile_class = 'u-text-align-mobile--right'
        else
          text_alignment_mobile_class = 'u-text-align-mobile--center'
        end

        # Add extra padding between rows
        padding_class = (item.respond_to? :padding_extra) ? ("u-padding-top--" + item.padding_extra) : nil

        # Add side paddings
        side_padding_class = (item.respond_to? :side_padding) ? ("u-padding-left-right--" + item.side_padding) : nil

        # PIDs Image replacement
        image_replacement_1 = (item.respond_to? :image_replacement_1) ? item.image_replacement_1.url : nil
        image_replacement_2 = (item.respond_to? :image_replacement_2) ? item.image_replacement_2.url : nil
        image_replacement_3 = (item.respond_to? :image_replacement_3) ? item.image_replacement_3.url : nil
        image_replacement_4 = (item.respond_to? :image_replacement_4) ? item.image_replacement_4.url : nil

        # Featured hero tile (get only the number from something like "1st Tile")
        tile_featured = (item.respond_to? :tile_featured) ? (item.tile_featured.chr.to_i - 1) : nil

        # Hero tile text
        text = (item.respond_to? :text) ? item.text : nil

        # Collapsible entries
        collapsible_entries = (item.respond_to? :collapsible_entries_container) ? map_editorials(item.collapsible_entries_container) : nil
        custom_css_class = (item.respond_to? :custom_css_class) ? item.custom_css_class : nil
        first_entry_expanded = (item.respond_to? :first_entry_expanded) ? item.first_entry_expanded : false

        {
          id: item_id,
          name: item_name,
          lg_item: lg_item,
          md_item: md_item,
          sm_items: sm_items,
          content_tiles: content_tiles,
          lg_items: lg_items,
          collapsible_entries: collapsible_entries,
          email_text: email_text,
          button_label: button_label,
          relative_url: relative_url,
          floating_email_scroll_percentage: floating_email_scroll_percentage,
          tile_cta: tile_cta,
          tile_cta_position: tile_cta_position,
          tile_cta_alignment: tile_cta_alignment,
          full_width_content_class: full_width_content_class,
          overlay_pids: overlay_pids,
          image: desktop_image,
          mobile_image: mobile_image,
          video: desktop_video,
          mobile_video: mobile_video,
          tile_url: tile_url,
          text_alignment_desktop_class: text_alignment_desktop_class,
          text_alignment_mobile_class: text_alignment_mobile_class,
          padding_class: padding_class,
          side_padding_class: side_padding_class,
          image_replacement_1: image_replacement_1,
          image_replacement_2: image_replacement_2,
          image_replacement_3: image_replacement_3,
          image_replacement_4: image_replacement_4,
          tile_featured: tile_featured,
          text: text,
          custom_css_class: custom_css_class,
          first_entry_expanded: first_entry_expanded
        }
      end

      meta_title = (parent_container.respond_to? :meta_title) ? parent_container.meta_title : nil
      meta_description = (parent_container.respond_to? :meta_description) ? parent_container.meta_description : nil
      site_version = (parent_container.respond_to? :site_version) ? parent_container.site_version : 'all'

      # When the LP is oriented to a specific site version (AU or US), this is where users are redirected to
      site_version_url_to_redirect = (parent_container.respond_to? :site_version_url_to_redirect) ? parent_container.site_version_url_to_redirect : :best_sellers

      # Check if the LP requests an extra spacing between top navigation and content
      page_white_spacing_top = (parent_container.respond_to? :page_white_spacing_top) ? parent_container.page_white_spacing_top : nil

      if page_white_spacing_top
        page_white_spacing_top_class = 'app-container--top-margin'
      end

      page_url = parent_container.relative_url

      # Fade-in/out during scroll
      fade_scroll = (parent_container.respond_to? :fade_scroll) ? parent_container.fade_scroll : false

      {
        page_url: page_url,
        header: main_header_tile,
        rows: row_tiles,
        meta_title: meta_title,
        meta_description: meta_description,
        site_version: site_version.downcase,
        site_version_url_to_redirect: site_version_url_to_redirect,
        page_white_spacing_top_class: page_white_spacing_top_class,
        fade_scroll: fade_scroll
      }
    end

  end

  class Version
    VERSION_CACHE_KEY = 'contentful_route_content'

    # returns the payload
    def self.fetch_payload(preview)
      if preview
        self.new_or_update.payload
      else
        current = Rails.cache.fetch(VERSION_CACHE_KEY) do
          contentful_payload = ContentfulVersion.where(is_live: true).last&.payload

          if contentful_payload
            all_routes = ContentfulRoute.pluck(:route_name)
            sifted = contentful_payload.select { |key, _| all_routes.include?(key)}
            # need to add the homepage route manually
            sifted["/"] = contentful_payload["/"]
            sifted
          else
            Raven.capture_exception(Exception.new("No ContentfulVersion set live."))
            #show 2nd to last version
            ContentfulVersion.offset(1).last&.payload
          end
        end
      end
    end

    # pull datas from contentful and
    def self.new_or_update
      #grab last row and figure it out
      last_v = ContentfulVersion.last

      if (last_v.nil? || last_v.is_live)
        #make a new entry if there are none, or the last one is live version
        ContentfulVersion.create({
          payload: Service.get_all_contentful_containers
        }, without_protection: true)
      else
        last_v.payload = Service.get_all_contentful_containers
        last_v.save!
        last_v
      end
    end

    # set the last version to live!
    def self.set_live(user, change_message)
      last_v = ContentfulVersion.last

      if last_v.is_live
        #can't set a version live if one has never been previewed
        false
      else
        current = ContentfulVersion.where(is_live: true).last
        current.is_live = false
        current.save!

        last_v.user = user
        last_v.is_live = true
        last_v.change_message = change_message
        last_v.save!
        clear_version_cache
        true
      end
    end

    def self.clear_version_cache
      Rails.cache.delete(VERSION_CACHE_KEY)
    end
  end

end
