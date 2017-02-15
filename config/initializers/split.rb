# This is the intializer for our Split test experiments
Split.configure do |config|
  config.experiments = {
    main_nav: {
      alternatives: ["mega", "simplified_var_1"],
      metric: :add_to_cart
    }
  }
end
