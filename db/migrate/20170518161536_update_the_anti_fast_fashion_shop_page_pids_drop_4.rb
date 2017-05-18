class UpdateTheAntiFastFashionShopPagePidsDrop4 < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/the-anti-fast-fashion-shop").first
    if page.present?
      # TODO: add "Drop 4" PIDs before the current PID list
      page.variables = {"lookbook" => true, "limit" => 200, "curated" => true, "pids" => %w(1454-pretty-pink 1501-pretty-pink 1514-navy 1511-navy 1511-red 1510-black 1517-silver 1515-black 1516-black 1512-red 1513-black 1517-black 1450-navy 1506-white 1502-etched-floral 1508-falling-floral 1468-white 1503-etched-floral 1509-falling-floral 1505-faded-floral 1448-dark-tan 1444-white 1518-black 1447-dark-tan 1504-faded-floral 1507-pale-blue-and-white-pinstripe 1466-white 1481-pale-pink 1469-red 1463-pale-pink 1495-pale-pink 1482-black-and-white-gingham 1473-red 1500-white 1467-white 1472-red 1465-pretty-pink 1490-black-and-white-gingham 1474-black 1462-red 1459-black 1469-black 1496-navy-stripe 1477-black-and-white-spot 1492-navy 1497-black-and-white-spot 1460-red 1489-navy-stripe 1484-black-and-white-gingham 1480-white 1491-pale-blue 1499-navy-stripe 1494-black-and-white-spot 1476-white 1479-black 1487-black-and-white-gingham 1464-white 1476-black 1475-pale-pink 1488-white 1470-black 1478-pale-pink 1483-silver 1493-navy 1479-dark-nude 1471-red 1468-red 1458-black 1485-black-and-white-spot 1498-navy-stripe 1459-red 1461-black 1486-navy 1440-white 1448-olive 1438-pale-pink 1443-black 1455-white-and-black-pinstripe 1452-navy 1435-white 1449-white-and-black-pinstripe 1450-olive 1451-olive 1446-white-and-black-pinstripe 1454-olive 1457-white 1444-black 1436-pale-pink 1447-pretty-pink 1435-olive 1386-navy 1453-white-and-black-pinstripe 1456-navy-and-white-pinstripe 1442-black 1437-silver 1451-black 1439-silver 1445-white 1441-white 1383-white-and-red-stripe 1438-white 1278-red).join(',')}
      page.save!
    end
  end
end
