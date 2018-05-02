class UpdateWeddingsPartiesSllPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: '/weddings-parties-say-lou-lou').first
    if page.present?
      page.variables["pids"] = '1292-black-heavy-georgette,1292-navy-heavy-georgette,1109-spring-posey-heavy-georgette,1670-spring-posey-light-georgette,1285-pale-blue-heavy-georgette,1693-lilac-corded-lace,1695-pale-blue-heavy-georgette,1706-black-sandwashed-silk,1655-blue-grey-light-silk-charmeuse,1655-pretty-pink-heavy-georgette,1364-pretty-pink-heavy-georgette,1705-dark-mint-light-silk-charmeuse,1443-ivory-medium-silk-charmeuse,1708-olive-sandwashed-silk,1647-ivory-heavy-georgette,1647-lilac-heavy-georgette,1687-bordeaux-light-silk-charmeuse,1687-bubblegum-pink-medium-silk-charmeuse,1262-ivory-medium-silk-charmeuse,1707-black-light-silk-charmeuse'
      page.save!
      page.publish!
    end
  end
  def down
    page = Revolution::Page.where(path: '/weddings-parties-say-lou-lou').first
    if page.present?
      page.variables["pids"] = '1292-black-heavy-georgette,1292-navy-heavy-georgette,1109-spring-posey-heavy-georgette,1670-spring-posey-light-georgette,1704-lilac-light-silk-charmeuse,1704-black-light-silk-charmeuse,1695-pale-blue-heavy-georgette,1706-black-sandwashed-silk,1655-blue-grey-light-silk-charmeuse,1655-pretty-pink-heavy-georgette,1364-pretty-pink-heavy-georgette,1705-dark-mint-light-silk-charmeuse,1443-ivory-medium-silk-charmeuse,1708-olive-sandwashed-silk'
      page.save!
      page.publish!
    end
  end
end
