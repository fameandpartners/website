module StripeHelper
  def get_stripe_key()
    if Rails.env.production?
      if current_site_version.is_australia?
        current_stripe_key = ENV.fetch('STRIPE_PUBLIC_AU_PROD')
      else
        current_stripe_key = ENV.fetch('STRIPE_PUBLIC_US_PROD')
      end
    else
      if current_site_version.is_australia?
        current_stripe_key = ENV.fetch('STRIPE_PUBLIC_AU_TEST')
      else
        current_stripe_key = ENV.fetch('STRIPE_PUBLIC_US_TEST')
      end
    end
  end
end
