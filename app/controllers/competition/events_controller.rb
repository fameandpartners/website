class Competition::EventsController < ApplicationController
  before_filter :authenticate_spree_user!

  def share
    participation = CompetitionParticipation.find_by_spree_user_id(spree_current_user.id)

    participation.increment!(:shares_count) if participation.present?

    head :ok
  end
end