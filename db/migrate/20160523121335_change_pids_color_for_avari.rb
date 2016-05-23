class ChangePidsColorForAvari < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/bridal-dresses").first
    if page.present?
      page.variables["pids"] = "824-white,823-white,537-white,825-white,579-ivory,821-white,829-white,830-white,826-white,345-white,262-white,721-champagne,805-white,629-ivory,752-ivory,828-white,822-white,819-white,816-white,360-white,97-white,814-white,466-white,620-white,582-white,827-white,283-white,820-white,185-white,639-white,495-white,497-white,503-white,517-white,634-ivory,725-white,415-white,414-white,474-ivory,522-white,817-white,481-nude"
      page.save!
    end
  end

  def down
    #NOOP
  end
end
