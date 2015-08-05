module MemoizationSupport
  def rememoize(klass, instance_variable_symbol)
    klass.instance_variable_set(instance_variable_symbol, nil)
  end
end

RSpec.configure do |config|
  config.include MemoizationSupport, memoization_support: true
end
