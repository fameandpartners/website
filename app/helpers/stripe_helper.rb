module StripeHelper
  def get_stripe_key()

    stripe_public_us_test = 'pk_test_W2TXpgZbnoebFKeDzNW74xhB'
    stripe_public_us_prod = 'pk_live_MaBBVDshRhR7V9jk4mfB89UE'
    stripe_public_au_test = 'pk_test_ic3pWUfqR66brmOJ01TrE5Lf'
    stripe_public_au_prod = 'pk_live_06GugZv2uL6y6kah0Gx7RtFv'

    if Rails.env.production?
      if current_site_version.is_australia?
        current_stripe_key = stripe_public_au_prod
      else
        current_stripe_key = stripe_public_us_prod
      end
    else
      if current_site_version.is_australia?
        current_stripe_key = stripe_public_au_test
      else
        current_stripe_key = stripe_public_us_test
      end
    end
  end
end
