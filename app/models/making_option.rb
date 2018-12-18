class MakingOption < ActiveRecord::Base
  attr_accessible :code, :name, :description, :delivery_period, :cny_delivery_period, :making_time_business_days, :cny_making_time_business_days, :flat_price_usd, 
    :flat_price_aud, :percent_price_usd, :percent_price_aud, :position,
    :delivery_time_days, :cny_delivery_time_days

  def flat_price_in(currency)
    if currency.downcase == 'aud'
      return self.flat_price_aud.to_f
    else
      return self.flat_price_usd.to_f
    end
  end

  def percent_price_in(currency)
    if currency.downcase == 'aud'
      return self.percent_price_aud.to_f
    else
      return self.percent_price_usd.to_f
    end
  end

  def display_price(currency)
    MakingOption.display_price(flat_price_in(currency), percent_price_in(currency), currency)
  end

  def is_cny?(date)
    return false unless cny_start_date && cny_end_date

    cny_start_date <= date && cny_end_date >= date
  end

  def display_delivery_period(date)
    if is_cny?(date)
      cny_delivery_period
    else
      delivery_period
    end
  end

  def self.display_price(flat, percent, currency)
    if percent && percent != 0
      if percent < 0 
        (percent*100*(-1)).round.to_s + '% OFF'
      else
        '+' + percent*100.round.to_s + '%'
      end
    elsif flat && flat != 0
      '$' + '%.2f' % flat
    else
      'FREE'
    end
  end
end
