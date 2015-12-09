class UpdateCarouselBridePage < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/fameweddings/bride").first
    if page.present?
      page.variables = {"limit" => 16, "caroulsel_pids" => "345-white,262-white,829-white,824-white,822-white,805-white,185-white,474-white,814-white,823-white,830-white,821-white,826-white,517-white,828-white,827-white"}
      page.save!
    end

    page = Revolution::Page.where(path: "/fameweddings/bridesmaid").first
    if page.present?
      page.variables = {"limit" => 20, "caroulsel_pids" => "800-pale-blue,793-ice-grey,803-blue-fallen-leaves,791-indigo,672-pale-pink,809-blue-fallen-leaves,813-navy,799-ice-blue,444-lilac,441-steel,697-blush,97-navy,607-lavender,570-pink,414-ice-grey,185-blush,430-pale-pink,493-pale-blue,445-ivory,340-cherry-red"}
      page.save!
    end
  end
end
