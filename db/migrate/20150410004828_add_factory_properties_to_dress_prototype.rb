class AddFactoryPropertiesToDressPrototype < ActiveRecord::Migration
  def up
    qry = <<-SQL.strip_heredoc
    WITH
    dress_prototype AS (SELECT *
                        FROM spree_prototypes
                        WHERE name = 'Dress'),
    factory_properties AS (SELECT *
                           FROM spree_properties
                           WHERE name LIKE 'factory_%'),
    factory_prototype_properties AS (SELECT
                                       dress_prototype.id    AS prototype_id,
                                       factory_properties.id AS property_id
                                     FROM dress_prototype
                                       JOIN factory_properties ON TRUE),
    new_prototype_properties AS (SELECT * FROM factory_prototype_properties
                                 EXCEPT SELECT * FROM spree_properties_prototypes)
    INSERT INTO
      spree_properties_prototypes
      SELECT * FROM new_prototype_properties;
    SQL
    execute qry
  end

  def down
    deletion_sql = <<-SQL.strip_heredoc
    WITH factory_properties AS (SELECT *
                            FROM spree_properties
                            WHERE name LIKE 'factory_%')
    DELETE FROM spree_properties_prototypes
    WHERE property_id IN (SELECT id FROM factory_properties);
    SQL

    execute deletion_sql
  end
end
