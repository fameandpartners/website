# This is the intializer for our Split test experiments
Split.configure do |config|
  config.experiments = {
    main_nav: {
      alternatives: ["mega", "simplified_var_1"],
      metric: :add_to_cart
    }
  }
end

# Apps without activesupport
Split::Dashboard.use Rack::Auth::Basic do |username, password|
  # Protect against timing attacks:
  # - Use & (do not use &&) so that it doesn't short circuit.
  # - Use digests to stop length information leaking
  Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SPLIT_USERNAME"])) &
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SPLIT_PASSWORD"]))
end
