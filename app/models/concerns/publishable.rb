module Concerns
  module Publishable
    extend ActiveSupport::Concern

    included do
      attr_accessible :published_at

      scope :published, -> { where('published_at <= ?', Time.zone.now) }
    end

    def publish!
      update_attribute :published_at, Time.zone.now
    end
  end
end
