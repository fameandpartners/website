require File.expand_path('../../test_helper', __FILE__)

module Stripe
  class EphemeralKeyTest < Test::Unit::TestCase
    context "#create" do
      should "succeed" do
        key = Stripe::EphemeralKey.create(
          {customer:"cus_123"},
          {stripe_version:"2017-05-25"}
        )

        assert_requested(
          :post,
          "#{Stripe.api_base}/v1/ephemeral_keys",
          headers: {'Stripe-Version' => '2017-05-25'}
        )

        assert key.kind_of?(Stripe::EphemeralKey)
      end

      context "#no global version" do
        should "use the correct api version" do
          key = Stripe::EphemeralKey.create(
            {customer: "cus_123"},
            {stripe_version: "2017-06-05"}
          )

          assert_requested(
            :post,
            "#{Stripe.api_base}/v1/ephemeral_keys",
            headers: {'Stripe-Version' => '2017-06-05'}
          )

          assert key.kind_of?(Stripe::EphemeralKey)
        end

        should "error without an explicit api version" do
          e = assert_raises(ArgumentError) do
            Stripe::EphemeralKey.create(customer: "cus_123")
          end
          assert_match("stripe_version must be specified", e.message)
        end
      end

      context "#with global version" do
        setup do
          Stripe.api_version = "2017-05-25"
        end

        teardown do
          Stripe.api_version = nil
        end

        should "use the correct api version" do
          key = Stripe::EphemeralKey.create(
            {customer: "cus_123"},
            {stripe_version: "2017-05-25"}
          )

          assert key.kind_of?(Stripe::EphemeralKey)
        end

        should "error without an explicit api version" do
          e = assert_raises(ArgumentError) do
            Stripe::EphemeralKey.create(customer: "cus_123")
          end
          assert_match("stripe_version must be specified", e.message)
        end
      end
    end

    context "#delete" do
      should "succeed" do
        key = Stripe::EphemeralKey.create(
          {customer: 'cus_123'},
          {stripe_version: '2017-05-25'}
        )

        key.delete
        assert_requested :delete, "#{Stripe.api_base}/v1/ephemeral_keys/#{key.id}"
      end
    end
  end
end
