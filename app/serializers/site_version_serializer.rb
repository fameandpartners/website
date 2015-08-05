class SiteVersionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :name, :permalink, :currency, :url_prefix

  def url_prefix
    object.to_param
  end
end
