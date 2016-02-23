# An API compatible replacement for Redis
# Provides `get/set` for use with Rollout.

class SimpleKeyValue < ActiveRecord::Base
  attr_accessible :key, :data

  validate :key, :presence => true, :uniqueness => true

  def self.set(key, value)
    feature_flag = where(key: key).first_or_create
    feature_flag.update_attributes!(data: value)
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    false
  end

  def self.get(key)
    where(key: key).first.try(:data)
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    false
  end

  # Rollout does not define the ability to remove a feature, only turn it off
  # Note that there is no `.add_feature()` method, as Features/Rollout will
  # automatically add the feature as soon as any code checks for the feature name.
  class FeatureMigration
    def self.remove_feature(feature_name)
      feature_key = "feature:#{feature_name}"

      SimpleKeyValue.delete_all(key: feature_key)

      if (features_list = SimpleKeyValue.where(key: 'feature:__features__').first)
        features_list.data = drop_item_from_list(features_list.data, feature_name)
        features_list.save!
      end
    end

    def self.drop_item_from_list(list, item)
      list.split(',').reject { |x| x == item }.join(',')
    end
  end
end
