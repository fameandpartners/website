# usage
# StyleQuiz::UserStyleProfiles::UserAnswersUpdater
#   - style_profile require
#   - site_version required for date format
#   - date_format : setted format for dates in & out
#
# apply:
#   answers: {
#     fullname
#     birthday
#     email
#     ids
#     events: { 
#       index: { name:, event_type:, date }
#     }
#   } 
module StyleQuiz
  module UserStyleProfiles
    class UserAnswersUpdater
      attr_reader :style_profile, :date_format

      def initialize(style_profile:, site_version: nil, date_format: nil)
        @style_profile = style_profile
        @date_format   = date_format || I18n.t('date_format.backend', locale: site_version.try(:locale))
      end

      def apply(answers = {})
        update_profile(answers)
        update_events((answers[:events] || {}).values)
        mark_as_completed

        true
      rescue
        false
      end

      private

        def update_profile(answers)
          style_profile.assign_attributes(
            fullname: answers[:fullname],
            email:    answers[:email],
            birthday: prepare_date(answers[:birthday])
          )
          style_profile.answer_ids = answers[:ids]
          style_profile.tags = HashWithIndifferentAccess.new(StyleQuiz::Answer.get_weighted_tags(ids: answers[:ids]))

          style_profile.save!
        end

        def update_events(events_data)
          event_builder = ::StyleQuiz::Events::EventBuilder.new(
            date_format: date_format,
            style_profile: style_profile
          )
          style_profile.events = events_data.map do |event_data|
            event_builder.create(event_data) rescue nil
          end.compact

          style_profile.events
        end

        def mark_as_completed
          return if style_profile.completed_at.present?

          # TODO: add check if profily actually finished
          style_profile.update_column(:completed_at, Time.now)
        end

        def prepare_date(raw_date)
          return nil if raw_date.blank?
          Date.strptime(raw_date, date_format)
        rescue
          nil
        end
    end
  end
end
