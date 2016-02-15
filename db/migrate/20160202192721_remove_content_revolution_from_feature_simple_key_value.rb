class RemoveContentRevolutionFromFeatureSimpleKeyValue < ActiveRecord::Migration
  class SimpleKeyValue < ActiveRecord::Base
    attr_accessible :key, :data
  end

  def up
    if (revolution_feature = SimpleKeyValue.where(key: 'feature:content_revolution').first)
      revolution_feature.destroy
    end

    if (features_list = SimpleKeyValue.where(key: 'feature:__features__').first)
      feature_list_ary   = features_list.data.split(',').reject { |feat| feat == 'content_revolution' }
      features_list.data = feature_list_ary.join(',')
      features_list.save!
    end
  end

  def down
    unless SimpleKeyValue.exists?(key: 'feature:content_revolution')
      SimpleKeyValue.create(key: 'feature:content_revolution', data: '100|')
    end

    if (features_list = SimpleKeyValue.where(key: 'feature:__features__').first)
      feature_list_ary   = features_list.data.split(',') + ['content_revolution']
      features_list.data = feature_list_ary.join(',')
      features_list.save!
    end
  end
end
