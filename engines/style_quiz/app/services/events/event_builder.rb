module StyleQuiz
  module Events
    class EventBuilder
      attr_reader :style_profile, :date_format

      def initialize(style_profile:, site_version: nil)
        @style_profile  = style_profile
        @date_format    = I18n.t('date_format.backend', locale: site_version.try(:locale))
      end

      def build(args)
        style_profile.events.new(event_attributes(args))
      end

      def create(args)
        event = build(args)
        event.save!

        event
      end

      private

        def event_attributes(args)
          date = Date.strptime(args[:date], date_format) rescue nil
          {
            name: args[:name],
            event_type: args[:event_type],
            date: date
          }
        end
    end
  end
end
