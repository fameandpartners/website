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

      {
        image: fetched_lg_container.image.url,
        # mobile_image: fetched_lg_container.mobile_image.url,
        overlay_pids: fetched_lg_container.overlay_pids
      }
    end

    def self.jsonify_medium_lp_container(medium_container)
      id = medium_container.id

      fetched_md_container = @contentful_client.entries('sys.id' => id)[0]

      if (fetched_md_container.content_type.id == 'ITEM--md-text')
        {
          id: 'ITEM--md-text',
          text: fetched_md_container.content.split("\n"),
          text_size: fetched_md_container.text_size
        }
      else
        # 'ITEM--md-email'
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
        email_text = (main_header_container.respond_to? :email_capture_text) ? main_header_container.email_capture_text : nil

        {
          id: main_header_container.content_type.id,
          header_lg_item: header_lg_item,
          header_text: main_header_container.header_text,
          email_capture: main_header_container.show_email_capture,
          email_text: email_text,
          header_sm_items: header_sm_items
        }
      elsif (main_header_container.content_type.id == 'HEADER--xl-editorial')
        {
          id: main_header_container.content_type.id,
          image: main_header_container.image.url,
          # mobile_image: main_header_container.mobile_image.url,
          overlay_pids: main_header_container.overlay_pids
        }
      end
    end

    def self.create_landing_page_container(parent_container)

      main_header_tile = jsonify_header_container(parent_container.header)

      row_tiles = parent_container.rows_container.map do |item|

        lg_item = (item.respond_to? :editorial_container) ? jsonify_large_lp_container(item.editorial_container) : nil
        md_item = (item.respond_to? :header_container) ? jsonify_medium_lp_container(item.header_container) : nil
        sm_items = (item.respond_to? :pids) ? item.pids : nil
        email_text = (item.respond_to? :email_header_text) ? item.email_header_text : nil

        {
          id: item.content_type.id,
          lg_item: lg_item,
          md_item: md_item,
          sm_items: sm_items,
          email_text: email_text
        }
      end

      meta_title = (parent_container.respond_to? :meta_title) ? parent_container.meta_title : nil
      meta_description = (parent_container.respond_to? :meta_description) ? parent_container.meta_description : nil

      parent_container.relative_url
      {
        header: main_header_tile,
        rows: row_tiles,
        meta_title: meta_title,
        meta_description: meta_description
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
