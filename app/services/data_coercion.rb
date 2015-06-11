module DataCoercion
  module_function
  def string_to_boolean(value, default: false)
    !! Coercible::Coercer.new[String].to_boolean(value.to_s)
  rescue Coercible::UnsupportedCoercion => _e
    !! default
  end
end
