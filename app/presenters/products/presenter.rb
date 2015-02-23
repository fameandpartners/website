module Products
  class Presenter < OpenStruct

    def customization_options
      if is_customizable?
        customizations.all.collect { |c| {id: c.id, name: c.name, price: c.display_price.to_s} }   
      else
        {}
      end
    end

    def is_customizable?
      customizations.present? && customizations.any?
    end

    def customizations
      @customizations ||= available_options.customizations
    end

  end
end