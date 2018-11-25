class ShippingStatePresenter

  attr_reader :shippable_item

  def initialize(shippable_item)
    @shippable_item = shippable_item

    [:shipped?, :projected_delivery_date, :shipped_at].map do |m|
      raise ArgumentError.new("#{shippable_item.class.name} does not implement #{m}") unless shippable_item.respond_to? m
    end
  end

  def present
    "#{days_remaining.abs} #{delivery_state.capitalize}"
  end

  def delivery_state
    case overdue_by
    when 11..999
      'critical'
    when 7..10
      'urgent'
    when 1..6
      'overdue'
    when -2..1
      'due'
    when -10..-3
      'ok'
    else
      'unknown'
    end
  end

  def overdue_by
    -days_remaining
  end

  def days_remaining
    @days_remaining ||= (expected_delivery_date - actual_delivery_date_or_now).to_i
  rescue StandardError => e
    0
  end

  private

  def expected_delivery_date
    shippable_item.ship_by_date.to_date
  end

  def actual_delivery_date_or_now
    (shippable_item.shipped? ? shippable_item.shipped_at : Date.current).to_date
  end

  def overdue?
    days_remaining < 0
  end
end
