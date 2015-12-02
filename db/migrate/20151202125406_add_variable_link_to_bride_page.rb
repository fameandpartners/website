class AddVariableLinkToBridePage < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/fameweddings/guest").first
    if page.present?
      page.variables = {"dresses_carousel_link" => "/dresses/?pids[]=796-blush-and-black&pids[]=795-coral&pids[]=811-sage-fallen-leaves&pids[]=797-mint&pids[]=792-aqua&pids[]=789-nautical-stripe&pids[]=794-ice-grey&pids[]=810-lilac&pids[]=802-ice-grey&pids[]=806-teal&pids[]=801-sage-fallen-leaves&pids[]=670-apricot&pids[]=575-surreal-floral-black&pids[]=515-light-pink&pids[]=674-rosebud&pids[]=666-bright-lavender&limit=16"}
      page.save!
    end

    page = Revolution::Page.where(path: "/fameweddings/bride").first
    if page.present?
      page.variables = {"dresses_carousel_link" => "/dresses?pids[]=345-white&pids[]=262-white&pids[]=853-white&pids[]=703-white&pids[]=846-white&pids[]=805-white&pids[]=185-white&pids[]=474-white&pids[]=838-white&pids[]=847-white&pids[]=854-white&pids[]=845-white&pids[]=850-white&pids[]=517-white&pids[]=852-white&pids[]=851-white&limit=16"}
      page.save!
    end

    page = Revolution::Page.where(path: "/fameweddings/bridesmaid").first
    if page.present?
      page.variables = {"dresses_carousel_link" => "/dresses?pids[]=800-pale-blue&pids[]=793-ice-grey&pids[]=803-blue-fallen-leaves&pids[]=791-indigo&pids[]=823-pale-pink&pids[]=809-blue-fallen-leaves&pids[]=813-navy&pids[]=799-ice-blue&pids[]=444-lilac&pids[]=441-steel&pids[]=697-blush&pids[]=97-navy&pids[]=607-lavender&pids[]=570-pink&pids[]=414-ice-grey&pids[]=185-blush&pids[]=430-pale-pink&pids[]=493-pale-blue&pids[]=445-ivory&pids[]=340-cherry-red&limit=20"}
      page.save!
    end
  end
end
