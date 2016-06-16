Spree::Money.class_eval do

  def ==(obj)
    self.class == obj.class && @money == obj.money
  end
end
