class TopBanner
  attr_reader :site_version

  def initialize(site_version)
    @site_version = site_version || SiteVersion.default
  end

  # Not using meta programming until we have more positions
  def right_text_key
    "#{site_version.code}_top_banner_right_text"
  end

  def center_text_key
    "#{site_version.code}_top_banner_center_text"
  end

  def right_text
    Spree::Config[right_text_key]
  end

  def center_text
    Spree::Config[center_text_key]
  end
end