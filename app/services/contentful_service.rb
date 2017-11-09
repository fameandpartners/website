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
        mobile_text = (item.respond_to? :mobile_text) ? item.mobile_text : nil
        sub_heading = (item.respond_to? :sub_heading) ? item.sub_heading : nil
        cta = (item.respond_to? :cta_button_text) ? item.cta_button_text : nil
        image = (item.respond_to? :image) ? item.image.url : nil
        mobile_image = (item.respond_to? :mobile_image) ? item.mobile_image.url : image
        hero_tile_site_version_array = (item.respond_to? :hero_tile_site_version) ? item.hero_tile_site_version.sort.join(',').downcase : nil

        if hero_tile_site_version_array == "au" || hero_tile_site_version_array == "us"
          hero_tile_site_version = hero_tile_site_version_array
        else
          hero_tile_site_version = "all"
        end

        {
          heading: heading,
          sub_heading: sub_heading,
          mobile_text: mobile_text,
          image: image,
          mobile_image: mobile_image,
          link: item.path_link,
          text_align: item.text_alignment,
          text_position: item.text_position,
          text_color: item.text_color,
          text_size: item.text_size,
          text_padding: item.text_padding,
          cta_button_text: cta,
          description: item.description,
          hero_tile_site_version: hero_tile_site_version
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

      if (fetched_lg_container.content_type.id == 'ITEM--lg')
        overlay_pids = (fetched_lg_container.respond_to? :overlay_pids) ? fetched_lg_container.overlay_pids : nil
        image_caption = (fetched_lg_container.respond_to? :image_caption) ? fetched_lg_container.image_caption : nil
        image_caption_color = (fetched_lg_container.respond_to? :image_caption_color) ? fetched_lg_container.image_caption_color : 'white'
        image_caption_url = (fetched_lg_container.respond_to? :image_caption_url) ? fetched_lg_container.image_caption_url : nil
        image_caption_link_target = (fetched_lg_container.respond_to? :image_caption_link_target) ? fetched_lg_container.image_caption_link_target : nil
        image_caption_link_target = image_caption_link_target ? '_blank' : '_self'

        {
          image: desktop_image,
          mobile_image: mobile_image,
          overlay_pids: overlay_pids,
          image_caption: image_caption,
          image_caption_color: image_caption_color,
          image_caption_url: image_caption_url,
          image_caption_link_target: image_caption_link_target
        }
      elsif (fetched_lg_container.content_type.id == 'ITEM--lg__carousel')
        tile_url = (fetched_lg_container.respond_to? :tile_url) ? fetched_lg_container.tile_url : nil
        tile_link_target = (fetched_lg_container.respond_to? :tile_link_target) ? fetched_lg_container.tile_link_target : nil
        tile_link_target = tile_link_target ? '_blank' : '_self'

        {
          image: desktop_image,
          mobile_image: mobile_image,
          tile_url: tile_url,
          tile_link_target: tile_link_target
        }
      end
    end

    def self.jsonify_medium_lp_container(medium_container)
      id = medium_container.id

      fetched_md_container = @contentful_client.entries('sys.id' => id)[0]

      if (fetched_md_container.content_type.id == 'ITEM--md-text')
        text_desktop = (fetched_md_container.respond_to? :content) ? fetched_md_container.content.split("\n") : nil
        text_mobile = (fetched_md_container.respond_to? :content_mobile) ? fetched_md_container.content_mobile.split("\n") : text_desktop

        {
          id: 'ITEM--md-text',
          text: text_desktop,
          text_mobile: text_mobile,
          text_size: fetched_md_container.text_size
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
        id = main_header_container.header_container.id
        subcontainer = @contentful_client.entries('sys.id' => id)[0]

        {
          id: main_header_container.content_type.id,
          text: subcontainer.content.split("\n"),
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
          overlay_pids: overlay_pids
        }
      elsif (main_header_container.content_type.id == 'HEADER--xl-editorial-carousel')
        carousel_items = (main_header_container.respond_to? :carousel_tiles) ? map_editorials(main_header_container.carousel_tiles) : nil
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
          carousel_items: carousel_items
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
        lg_item = (item.respond_to? :editorial_container) ? jsonify_large_lp_container(item.editorial_container) : nil
        lg_items = (item.respond_to? :editorials_container) ? map_editorials(item.editorials_container) : nil
        md_item = (item.respond_to? :header_container) ? jsonify_medium_lp_container(item.header_container) : nil
        sm_items = (item.respond_to? :pids) ? item.pids : nil
        email_text = (item.respond_to? :email_header_text) ? item.email_header_text : nil
        button_label = (item.respond_to? :button_label) ? item.button_label : nil
        relative_url = (item.respond_to? :relative_url) ? item.relative_url : nil
        floating_email_scroll_percentage = (item.respond_to? :floating_email_scroll_percentage) ? item.floating_email_scroll_percentage : nil

        # CTA Tiles
        tile_cta = (item.respond_to? :tile_cta_container) ? jsonify_small_lp_container(item.tile_cta_container) : nil
        tile_cta_position = (item.respond_to? :tile_cta_position) ? item.tile_cta_position : 4

        # Hero tiles content
        overlay_pids = (item.respond_to? :overlay_pids) ? item.overlay_pids : nil
        desktop_image = (item.respond_to? :image) ? item.image.url : nil
        mobile_image = (item.respond_to? :mobile_image) ? item.mobile_image.url : desktop_image
        full_width_content = (item.respond_to? :full_width_content) ? item.full_width_content.sort.join(',').downcase : nil

        if full_width_content == 'desktop,mobile'
          full_width_content_class = 'u-forced-full-width-wrapper u-forced-full-width-wrapper--mobile'
        elsif full_width_content == 'mobile'
          full_width_content_class = 'u-forced-full-width-wrapper--mobile'
        elsif full_width_content == 'desktop'
          full_width_content_class = 'u-forced-full-width-wrapper'
        end

        # Add padding options for specific modules
        padding_top = (item.respond_to? :padding_top) ? ("u-padding-top--" + item.padding_top) : nil
        padding_bottom = (item.respond_to? :padding_bottom) ? ("u-padding-bottom--" + item.padding_bottom) : nil
        padding_class = [padding_top, padding_bottom].compact.reject(&:empty?).join(' ')

        {
          id: item_id,
          lg_item: lg_item,
          md_item: md_item,
          sm_items: sm_items,
          email_text: email_text,
          button_label: button_label,
          relative_url: relative_url,
          lg_items: lg_items,
          floating_email_scroll_percentage: floating_email_scroll_percentage,
          tile_cta: tile_cta,
          tile_cta_position: tile_cta_position,
          full_width_content_class: full_width_content_class,
          overlay_pids: overlay_pids,
          image: desktop_image,
          mobile_image: mobile_image,
          padding_class: padding_class
        }
      end

      meta_title = (parent_container.respond_to? :meta_title) ? parent_container.meta_title : nil
      meta_description = (parent_container.respond_to? :meta_description) ? parent_container.meta_description : nil
      site_version = (parent_container.respond_to? :site_version) ? parent_container.site_version : 'all'

      # When the LP is oriented to a specific site version (AU or US), this is where users are redirected to
      site_version_url_to_redirect = (parent_container.respond_to? :site_version_url_to_redirect) ? parent_container.site_version_url_to_redirect : :best_sellers

      # Check if the LP requests an extra spacing between top navigation and content
      page_white_spacing_top = (parent_container.respond_to? :page_white_spacing_top) ? parent_container.page_white_spacing_top : nil

      page_url = parent_container.relative_url
      {
        page_url: page_url,
        header: main_header_tile,
        rows: row_tiles,
        meta_title: meta_title,
        meta_description: meta_description,
        site_version: site_version.downcase,
        site_version_url_to_redirect: site_version_url_to_redirect,
        page_white_spacing_top: page_white_spacing_top
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
