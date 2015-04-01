=begin
  usage:
    load(File.join(Rails.root, 'lib', 'promotions', 'generator.rb'))
    Promotions::Generator.new.create(1)
=end
#We need the ability to generate a large number of random promocodes.
#Promocode is always a 20% discount. We don't need to handle any other type at this stage.
#
#Codes should be in the form "fame#{randomstring}"
#  random string should be generated and 4-5 alpha characters
#  Codes should be unique
#  Codes should be for a single-use only
#  Codes should be valid for 12 months.

module Promotions
  class Generator
    def initialize(options = {})
    end

    def create_numeric(number = 1, start = 999, prefix)
      number = number.to_i.abs
      start = start.to_i.abs
      return promotions if number == 0
      finish = (start + number) - 1
      codes = (start..finish).to_a.collect{ |i| "#{prefix}#{i}" }
      generate_promotion(codes)
    end

    def create(number = 1, prefix)
      number = number.to_i.abs
      return promotions if number == 0
      codes = generate_unique_codes(number)
      generate_promotion(codes)
    end


    private

      def generate_promotion(codes)
        promotions = []

        codes.each do |code|
          promotion = build_promotion(code)

          promotion.promotion_actions = build_promotion_actions
          promotion.promotion_rules   = build_promotion_rules

          if promotion.save!
            promotions.push(promotion.code)
          end
        end

        promotions
      end

      #{ :promotion_actions, :promotion_rules }
      def build_promotion(code)
        promo = Spree::Promotion.new(
          description:  "20% off one-time promotion",
          starts_at:    1.day.ago,
          expires_at:   1.year.from_now,
          name:         code,
          code:         code,
          event_name:   "spree.checkout.coupon_code_added",
          usage_limit:  1,
          match_policy: 'all',
          advertise:    false,
          path:         ''
        )
      end

      def build_promotion_rules
        [
          Spree::Promotion::Rules::ItemTotal.new(preferred_amount: BigDecimal.new(100), preferred_operator: 'gt')
        ]
      end

      def build_promotion_actions
        Array.new(1) do |index|
          action = Spree::Promotion::Actions::CreateAdjustment.new
          action.calculator = Spree::Calculator::FlatPercentItemTotal.new(preferred_flat_percent: 20)
          action
        end
      end

      def generate_unique_codes(number)
        existing_codes = Spree::Promotion.pluck(:code)
        unique_codes = []
        iteration = 0
        while (unique_codes.size < number) && (iteration < 1000)  do
          iteration += 1
          code = generate_code
          if not existing_codes.include?(code)
            existing_codes.push(code)
            unique_codes.push(code)
          end
        end

        unique_codes
      end

      def generate_code
        prefix + available_characters.sample(5).join
      end

      # random string should be generated and 4-5 alpha characters
      def available_characters
        @available_characters ||= ('A'..'Z').to_a
      end
  end
end

# promotion.activate(:order => order, :coupon_code => promotion.code)
#   promo.actions.
#     action.perform(order: , coupon_code: )
# payload[:coupon_code]
