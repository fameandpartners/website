class SiteVersionSerializer < ActiveModel::Serializer
  attributes :name, :permalink, :currency, :url_prefix

  def url_prefix
    object.to_param
  end
end
