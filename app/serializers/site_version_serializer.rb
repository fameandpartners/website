class SiteVersionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :name, :permalink, :currency, :url_prefix

  def url_prefix
    object.to_param
  end

  def use_paths?
    configatron.site_version_detector_strategy == :path
  end
end
