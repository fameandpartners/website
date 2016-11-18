module Spree
  module WeddingAtelier
    class RegistrationsController < ApplicationController
      layout 'wedding_atelier'
      def signup
      end

      def size
        @heights = [
            [1, "5'19 / 177cm "],
            [2, "5'19 / 177cm "],
            [3, "5'19 / 177cm "],
            [4, "5'19 / 177cm "]
        ]

        @dress_sizes = [0, 2, 4, 5, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26]
      end

      def details
      end

      def invite
      end
    end
  end
end
