# An API compatible replacement for Redis
# Provides `get/set` for use with Rollout.

class FeatureFlag < ActiveRecord::Base
  attr_accessible :key, :data

  validate :key, :presence => true, :uniqueness => true

  def self.set(key, value)
    feature_flag = where(key: key).first_or_create
    feature_flag.update_attributes!(data: value)
  end

  def self.get(key)
    where(key: key).first.try(:data)
  end
end
