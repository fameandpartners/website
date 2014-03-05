class SiteVersionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :name, :permalink, :currency
end
