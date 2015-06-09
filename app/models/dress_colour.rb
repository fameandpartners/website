class DressColour < ActiveRecord::Base

  # Model is based on the `dress_colours`
  # view of `spree_option_values`
  #
  # Modify via the underlying Spree::OptionValue classes.
  def readonly?
    true
  end
end

