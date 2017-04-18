class UpdateEverybodydancePagePids < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/shop-every-body-dance").first
    if page.present?
      page.variables = {"lookbook" => true, "limit" => 99, "pids" => %w(909-icing-pink-and-red 1311-ivory 1358-black 917-black 1362-black 630-ivory 1348-navy 1287-black 1363-black 1285-black 1120-black 1356-black 1359-silver 1354-silver 1324-silver 1342-silver 1377-red 930-black 1332-pale-pink 1392-red 1340-black 1343-silver 1378-black 1345-warm-tan 968-black 1341-burgundy 1357-black 1370-navy).join(',')}
      page.save!
    end
  end
end
