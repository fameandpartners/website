module DateHelper
  def maybe_date(date, placeholder = '-')
    date.present? && date.respond_to?(:to_date) ? l(date.to_date) : placeholder
  end
end
