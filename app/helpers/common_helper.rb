module CommonHelper
  # override spree method
  # title method 
  def get_title
    # @title  : Spree::Config[:default_seo_title]
    title_string = @title.present? ? @title : accurate_title
    if title_string.present?
      title_string
    else
      [Spree::Config[:site_name], "Dream Formal Dresses"].join(' - ')
    end 
  end

  def get_meta_description
    if @description.present?
      @description
    else
      # default description or hardcoded
      default_meta_description
    end
  end
end

