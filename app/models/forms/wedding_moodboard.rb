module Forms
  class WeddingMoodboard < Reform::Form

    module SharedSelectionData
      def owner_relationships
        [
          "Choose an option",
          "Bride",
          "Maid of Honor",
          "Bridesmaid",
          "Mother of the bride",
          "Mother of the groom",
          "Groom"
        ]
      end

      def event_progressions
        [
          "Choose an option",
          "Engaged",
          "Ready for a ring",
          "Looking for someone special"
        ]
      end
    end
    include SharedSelectionData
    extend SharedSelectionData

    property :event_progress
    property :event_date
    property :owner_relationship
    property :guest_count
    property :bride_first_name
    property :bride_last_name
    property :name

    validates :owner_relationship, inclusion: { in: owner_relationships }
    validates :bride_first_name,   presence: true
  end
end


