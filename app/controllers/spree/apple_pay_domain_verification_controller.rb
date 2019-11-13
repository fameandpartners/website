# frozen_string_literal: true

module Spree
  # Apple Pay Domain Verification
  class ApplePayDomainVerificationController < Spree::BaseController
    def show
      gateway = Spree::Gateway::ApplePayStripe.active.last

      raise ActiveRecord::RecordNotFound unless gateway

      render plain: gateway.preferred_domain_verification_certificate
    end
  end
end
