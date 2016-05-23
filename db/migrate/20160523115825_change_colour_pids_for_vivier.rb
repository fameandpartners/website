class ChangeColourPidsForVivier < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/dresses/backless").first
    if page.present?
      page.variables["pids"] = "999-silver,919-black,539-berry,991-ivory,962-cherry-red,582-burgundy,977-olive-shimmer,191-black,889-pale-pink,1010-feather-love,940-ivory,632-navy,905-white,262-black,514-black,520-cobalt-blue,928-midnight-reptile,620-white,537-lilac,874-pale-grey"
      page.save!
    end
  end

  def down
    #NOOP
  end
end
