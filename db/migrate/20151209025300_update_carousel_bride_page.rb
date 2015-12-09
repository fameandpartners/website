class UpdateCarouselBridePage < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/fameweddings/bride").first
    if page.present?
      page.variables = {"limit" => 16, "caroulsel_pids" => "345-white,262-white,829-white,824-white,822-white,805-white,185-white,474-white,814-white,823-white,830-white,821-white,826-white,517-white,828-white,827-white"}
      page.save!
    end
  end
end
