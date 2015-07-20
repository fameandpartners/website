class Spree::OptionValue::ProductSize < Spree::OptionValue
  default_scope -> { where("option_type_id is not null").where(option_type_id: Spree::OptionType.size.try(:id)) }

  def value
    Integer(name)
  rescue 
    name.to_i
  end

  def allowed_size?
    value >= Spree::OptionValue::ProductSize.sizes_start && value <= Spree::OptionValue::ProductSize.sizes_end
  end

  def extra_size?
    value >= Spree::OptionValue::ProductSize.extra_sizes_start
  end
  alias_method :extra_size, :extra_size?

  def presentation
    [ au_presentation, us_presentation ].join('/')
  end

  def presentation_for(site_version: nil)
    self.class.site_version_presentation(value, site_version)
  end

  def au_presentation
    presentation_for(site_version: SiteVersion.australia)
  end

  def us_presentation
    presentation_for(site_version: SiteVersion.usa)
  end

  class << self
    def site_version_presentation(value, site_version)
      locale_code = site_version.size_settings.locale_code.upcase
      locale_size = value.to_i + site_version.size_settings.size_start

      "#{ locale_code }-#{ locale_size }"
    end

    def sizes_start
      0
    end

    def extra_sizes_start
      14
    end

    def sizes_end
      22
    end
  end
end
