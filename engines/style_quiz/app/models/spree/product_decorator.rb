Spree::Product.class_eval do
  serialize :tags, Array
end
