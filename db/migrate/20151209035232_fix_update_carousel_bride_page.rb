class FixUpdateCarouselBridePage < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/fameweddings/bride").first
    if page.present?
      page.variables = {"limit" => 16, "carousel_pids" => "345-white,262-white,829-white,824-white,822-white,805-white,185-white,474-white,814-white,823-white,830-white,821-white,826-white,517-white,828-white,827-white"}
      page.save!
    end

    page = Revolution::Page.where(path: "/fameweddings/bridesmaid").first
    if page.present?
      page.variables = {"limit" => 20, "carousel_pids" => "800-pale-blue,793-ice-grey,803-blue-fallen-leaves,791-indigo,672-light-pink,809-blue-fallen-leaves,813-navy,799-ice-blue,444-lilac,441-steel,697-blush,97-navy,607-lavender,570-pink,414-ice-grey,185-blush,430-pale-pink,493-pale-blue,445-ivory,340-cherry-red"}
      page.save!
    end

    page = Revolution::Page.where(path: "/fameweddings/guest").first
    if page.present?
      page.variables = {"limit"=>16, "carousel_pids"=>"796-blush-and-black,795-coral,811-sage-fallen-leaves,797-mint,792-aqua,789-nautical-stripe,794-ice-grey,810-lilac,802-ice-grey,806-teal,801-sage-fallen-leaves,670-apricot,575-surreal-floral-black,515-light-pink,674-rosebud,666-bright-lavender"}
      page.save!
    end
  end
end
