module WeddingAtelier
  module ApplicationHelper
    def registration?
      controller_name == 'registrations'
    end
  end
end
