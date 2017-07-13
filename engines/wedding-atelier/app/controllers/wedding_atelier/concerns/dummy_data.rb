module WeddingAtelier
  module Concerns
    module DummyData
      extend ActiveSupport::Concern

      private
      def set_dummy_data
        @dummy_event = Event.find_or_create_by_name("dummy", date: Date.today, number_of_assistants: 0)
        @dummy_user = Spree::User.find_or_initialize_by_first_name("dummy")
        if @dummy_user.new_record?
          @dummy_user.build_user_profile({ height: WeddingAtelier::Height.definitions.values.first[0],
                                         dress_size_id: Spree::OptionType.size.option_values.first.id })
          @dummy_user.save(validate: false)
        end
      end

    end
  end
end
