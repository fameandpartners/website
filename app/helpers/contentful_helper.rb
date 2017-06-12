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
      Raven.capture_exception(e)
      return {:hero_tiles=>[{:heading=>["Cute, custom", "clothing. All", "ethically made."], :sub_heading=>["<em>Shop Anti-Fast Fashion</em>"], :mobile_text=>["Cute, custom clothing.", "All ethically made.", "<em><strong>SHOP ANTI-FAST FASHION</strong></em>"], :image=>"//images.contentful.com/o546qnqj0du7/3gUrEDlMy48K86QOoyeso4/1184d8b37a094cc424e10f4bf51ed71c/Hero1-Desktop.jpg", :mobile_image=>"//images.contentful.com/o546qnqj0du7/1ZbHcRlFGQmyu0wMWES2Go/bfd471537b5525de66f0e3c7c99abccb/Hero1-Mobile.jpg", :link=>"/the-anti-fast-fashion-shop?hpbanner1v4", :text_align=>"Center", :text_position=>"Center", :text_color=>"Black", :text_size=>"Large", :text_padding=>"None", :cta_button_text=>nil, :description=>"The Anti-Fast Fashion Shop"}, {:heading=>["The modern wedding", "dress code dictates", "stand-out style."], :sub_heading=>["<em>Shop the Wedding Guest Collection</em>"], :mobile_text=>["<em>Shop the Wedding Guest Collection</em>"], :image=>"//images.contentful.com/o546qnqj0du7/2nFEjHutPys44oOi4UcIcy/990e2cba6966987f32b779777f0f08b0/Hero2-Desktop.jpg", :mobile_image=>"//images.contentful.com/o546qnqj0du7/4Nz6sSMm1Wy4YOuioogIie/bd8fcbdab7ae96d98d0720bd343d0d3c/Hero2-Mobile.jpg", :link=>"/modern-bridesmaid-dresses?hpbanner2v2", :text_align=>"Left", :text_position=>"Right", :text_color=>"Black", :text_size=>"Small", :text_padding=>"Left", :cta_button_text=>nil, :description=>"Modern Bridesmaid Dresses"}, {:heading=>["Pick your print,", "customize the fit."], :sub_heading=>nil, :mobile_text=>["Pick you print,", "customize the fit.", "<em><strong>SHOP GINGHAM & STRIPES</em></strong>"], :image=>"//images.contentful.com/o546qnqj0du7/3VsbK3Jl8cMeMKAYuOsewa/e5e6b64794c82a0b1b0c97111b91a9a5/Hero3-Desktop.jpg", :mobile_image=>"//images.contentful.com/o546qnqj0du7/5slfKrm1LauqgqAGIAysck/2b1784d8c7130dd2101886735d1abfe5/Hero3-Mobile.jpg", :link=>"/trends-gingham-stripe?hpbanner3", :text_align=>"Left", :text_position=>"Far-Right", :text_color=>"Black", :text_size=>"Large", :text_padding=>"Left", :cta_button_text=>["Shop Stripes & Gingham"], :description=>"Gingham & Stripes"}], :secondary_header=>{:image=>"//images.contentful.com/o546qnqj0du7/2m3q114GyUmKIEEasuYaIo/cdc4e5056eb3c08f9cfd147865364ab0/StyleIcon-Desktop.jpg", :mobile_image=>"//images.contentful.com/o546qnqj0du7/7I8viaqzIWSwY2UCskAS2a/d789cf53e88797db23638588460c1e30/StyleIcon-Mobile.jpg", :path_link=>"/dresses/wedding-guests?secondaryhp"}, :category_tiles=>[{:link=>"/dresses/lace?edit1", :title=>"Lace", :image=>"//images.contentful.com/o546qnqj0du7/3V7VadpNheS4wMC84C6oCO/9d9c325d59124410ed0a9c139ff0a9ee/Edit-01.jpg"}, {:link=>"/dresses/floral?edit2", :title=>"Florals", :image=>"//images.contentful.com/o546qnqj0du7/1evUgUAH6ImCCmCAwkQYYg/38d01e8bfa4cc0f22ede4e5932d73885/Edit-02.jpg"}, {:link=>"/trends-white?edit3", :title=>"White", :image=>"//images.contentful.com/o546qnqj0du7/1TxWNw3sk0ws6Gw4ImiEMs/a149377760cbf0064f953ee8ad5aa9f7/Edit-04.jpg"}, {:link=>"/dresses/jumpsuit?edit4", :title=>"Jumpsuits", :image=>"//images.contentful.com/o546qnqj0du7/5PhaiwFkLCAueeOg4OI0GM/b09897e882667a8596b53c6024ce06cf/Edit-03.jpg"}], :instagram_tiles=>[{:path_link=>"/dresses/dress-khiva-1223?color=dark-forest", :handle=>"@overmystylishbody", :image=>"//images.contentful.com/o546qnqj0du7/4jqIPGAA9Gg6yg4U4KowI4/f0143d07fcacce8621b8ae866ecac21f/1.jpg"}, {:path_link=>"/dresses/dress-harbourside-dress-1123?color=champagne", :handle=>"@kelsey_white", :image=>"//images.contentful.com/o546qnqj0du7/ypBQSXw1t6owOESaIceKc/f7f43aa6bdffc4026addf901f310718c/2.jpg"}, {:path_link=>"/dresses/dress-the-russo-dress-1544?color=navy-and-white-gingham", :handle=>"@lifestylecatcher", :image=>"//images.contentful.com/o546qnqj0du7/3SDAIoaOZOuwWe04GCCe84/d09ed9887771996d28aec7007f2a0926/3.jpg"}, {:path_link=>"/dresses/dress-kiko-kimono-coat-1262?color=dark-tan", :handle=>"@tosha_eason", :image=>"//images.contentful.com/o546qnqj0du7/23tM4O8eZC88K20uicKoKa/308a7777b27fab31f0d515a1fda75f8b/4.jpg"}, {:path_link=>"/dresses/dress-the-fernanda-pant-1451?color=olive", :handle=>"@shhtephs", :image=>"//images.contentful.com/o546qnqj0du7/ExqrX8eZFIOKK0OsOs2eK/e0b098880e546881393ad0910d9daed4/5.jpg"}]}
  end
end
