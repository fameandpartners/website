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

    rescue Exception => e
      return {:hero_tiles=>[{:heading=>["The Anti-Fast", "Fashion Shop."], :sub_heading=>["Everyday must-haves, ethically", "made-to-order. <em>Shop now.</em>"], :mobile_text=>["Everyday must-haves, ethically made-to-order.", "<strong>Shop now</strong>"], :image=>"//images.contentful.com/o546qnqj0du7/6mSiWbl1NCAO8MqkskMWUy/3eec91d6d988cdf78401a5479a4fd803/Hero1-Desktop.jpg", :mobile_image=>"//images.contentful.com/o546qnqj0du7/6ntEhTMBwWUuckiy48WuIQ/c4ed848accedfd9600f93784bd97bcbd/Hero1-Mobile.jpg", :link=>"/the-anti-fast-fashion-shop?hpbannerv3", :text_align=>"Left", :text_position=>"Right", :text_color=>"Black", :text_size=>"Large", :text_padding=>"None", :cta_button_text=>nil, :description=>"The Anti-Fast Fashion Shop"}, {:heading=>["<em>Break</em>", "tradition."], :sub_heading=>["Find a bridesmaid dress you", "<em>actually</em> want to wear."], :mobile_text=>["Find a bridesmaid dress you <em>actually</em> want to wear.", "<strong>Customize Now</strong>"], :image=>"//images.contentful.com/o546qnqj0du7/1pOJDKFu5KAMk20Kiiiei8/14288b1c03fef69909af461c185088f1/may-18-featured-2.jpg", :mobile_image=>"//images.contentful.com/o546qnqj0du7/7vZgJVw33qkWMAUWiwmyy4/3ea06a8bb671049d8eac287dafc05bd9/may-18-featured-2-mob.jpg", :link=>"/modern-bridesmaid-dresses?hpbanner2", :text_align=>"Left", :text_position=>"Right", :text_color=>"Black", :text_size=>"Large", :text_padding=>"Left", :cta_button_text=>["CUSTOMIZE", "NOW"], :description=>"Modern Bridesmaid Dresses"}, {:heading=>["You're <em>not</em>", "meant to", "blend in."], :sub_heading=>["Especially when you go out."], :mobile_text=>["You're <em>not</em> meant to blend in.", "<strong>Shop High Contrast</strong>"], :image=>"//images.contentful.com/o546qnqj0du7/1kis8vKZwCQYwU4ie2Socw/c1c6124975f295d2b7dd67beabe7651d/may-18-featured-3.jpg", :mobile_image=>"//images.contentful.com/o546qnqj0du7/7hXk8HXgsME8ssk8cgU602/f20ef4ac68795a6eba0866e92d6e5421/may-18-featured-3-mob.jpg", :link=>"/high-contrast?hpbanner3", :text_align=>"Left", :text_position=>"Center", :text_color=>"Black", :text_size=>"Large", :text_padding=>"None", :cta_button_text=>["SHOP", "HIGH CONTRAST"], :description=>"High Contrast"}], :secondary_header=>{:image=>"//images.contentful.com/o546qnqj0du7/1KUhHMcMMw028uWqUwCAkS/db77135ec3f99b0444e8530d56782416/StyleIcon-Desktop.jpg", :mobile_image=>"//images.contentful.com/o546qnqj0du7/S1NSBrDj0q2QSIWOCSKCm/9fe7c9222793fa83600e3beba2c8f3d0/StyleIcon-Mobile.jpg", :path_link=>"/get-the-look?secondaryhp"}, :category_tiles=>[{:link=>"/dresses/little-black-dress?edit1", :title=>"Black", :image=>"//images.contentful.com/o546qnqj0du7/4DutxbOjb2OikgKi8qgWyc/9e58102b351c9092899cb6f4f2176590/Edit-01.jpg"}, {:link=>"/dresses/floral?edit2", :title=>"Floral", :image=>"//images.contentful.com/o546qnqj0du7/4bykWYgBzWkaokcE6cciQM/d224d81e9e7ce02e97de044ee2f7c7c9/Edit-02.jpg"}, {:link=>"/trends-white?edit3", :title=>"White", :image=>"//images.contentful.com/o546qnqj0du7/3Zwr1vyLG0mwoqM20a46SI/b47fe59a03e9b35871e0b34f2b8a656f/Edit-03.jpg"}, {:link=>"/dresses/jumpsuit?edit4", :title=>"Jumpsuits", :image=>"//images.contentful.com/o546qnqj0du7/6gppD31m36M8WCMmUCQGag/b0c8fde4ee78f4e4e368b492421b9396/Edit-04.jpg"}], :instagram_tiles=>[{:path_link=>"/dresses/dress-the-preetma-pant-1479?color=black", :handle=>"@luxeandlinen", :image=>"//images.contentful.com/o546qnqj0du7/2P6E3aEks828KumgmaEsw/134b8875a262fa99675fd94ce270eeef/5.jpg"}, {:path_link=>"/dresses/dress-maquino-1198?color=red", :handle=>"@jessyasmus", :image=>"//images.contentful.com/o546qnqj0du7/41QfjONqs8y8sYcmKyAKSU/bab8b9c92d1442e7029ef880190f7d75/4.jpg"}, {:path_link=>"/dresses/dress-liesl-two-piece-1079?color=white", :handle=>"@mystyleandgrace", :image=>"//images.contentful.com/o546qnqj0du7/4ZtRDTbRzym2GeQiUWIGYi/ff3c0efe9826cbb1b54a244d7de24d10/1.jpg"}, {:path_link=>"/dresses/dress-merille-two-piece-1080?color=navy", :handle=>"@whitney_rene", :image=>"//images.contentful.com/o546qnqj0du7/3VeMYLavnO6c8cA2aCG2aW/08f952abbca87be28acd0f694b43fd72/2.jpg"}, {:path_link=>"/dresses/dress-the-irina-dress-1435?color=white", :handle=>"@thetinycloset", :image=>"//images.contentful.com/o546qnqj0du7/1TH9slt1S44eGiM6iiMAyw/5cf6d1a9e8640b4ef4fc68145e9726a2/3.jpg"}]}

  end
end
