class AddVariableLinkToBridePage < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/fameweddings/guest").first
    if page.present?
      page.variables = {"limit" => 16, "caroulsel_pids" => "796-blush-and-black,795-coral,811-sage-fallen-leaves,797-mint,792-aqua,789-nautical-stripe,794-ice-grey,810-lilac,802-ice-grey,806-teal,801-sage-fallen-leaves,670-apricot,575-surreal-floral-black,515-light-pink,674-rosebud,666-bright-lavender"}
      page.save!
    end

    page = Revolution::Page.where(path: "/fameweddings/bride").first
    if page.present?
      page.variables = {"limit" => 16, "caroulsel_pids" => "345-white,262-white,853-white,703-white,846-white,805-white,185-white,474-white,838-white,847-white,854-white,845-white,850-white,517-white,852-white,851-white"}
      page.save!
    end

    page = Revolution::Page.where(path: "/fameweddings/bridesmaid").first
    if page.present?
      page.variables = {"limit" => 20, "caroulsel_pids" => "800-pale-blue,793-ice-grey,803-blue-fallen-leaves,791-indigo,823-pale-pink,809-blue-fallen-leaves,813-navy,799-ice-blue,444-lilac,441-steel,697-blush,97-navy,607-lavender,570-pink,414-ice-grey,185-blush,430-pale-pink,493-pale-blue,445-ivory,340-cherry-red"}
      page.save!
    end
  end
end

