module Moodboards
  class WeddingsController < ApplicationController

    before_filter :authenticate_spree_user!

    private def search_scope
      spree_current_user.moodboards.weddings
    end

    private def wedding_name(name)
      "#{name.to_s.titleize}'s Wedding"
    end

    private def default_wedding_moodboard
      default_name = wedding_name(spree_current_user.first_name)

      moodboard = search_scope.first

      unless moodboard
        moodboard = search_scope.create(name: default_name)
      end
      moodboard
    end

    private def track_moodboard_update(moodboard)
      mb         = MoodboardsPresenter::MoodboardPresenter.new(moodboard)
      tracker    = Marketing::CustomerIOEventTracker.new
      trackable  = { id: mb.owner_email, email: mb.owner_email }
      extra_data = {
        moodboard_path:       mb.show_path,
        moodboard_url:        mb.show_url,
        moodboard_name:       mb.name,
        moodboard_owner_name: mb.owner_name,
      }

      tracker.client.identify(trackable)
      tracker.track(mb.owner_email, 'wedding_moodboard_update', extra_data)
    end

    def edit
      @moodboard = default_wedding_moodboard
      @moodboard_form = Forms::WeddingMoodboard.new(@moodboard)
    end

    def guests
      @moodboard = default_wedding_moodboard
    end

    def update
      candidate_id = params[:wedding_moodboard][:id].to_i

      @moodboard = search_scope.find(candidate_id)
      @moodboard_form = Forms::WeddingMoodboard.new(@moodboard)

      # TODO - Find a better way of changing the :name.
      if @moodboard_form.validate(params[:wedding_moodboard])
        @moodboard_form.name = wedding_name(@moodboard_form.bride_first_name)
        @moodboard_form.save
        track_moodboard_update(@moodboard)
        render :guests
      else
        render :edit
      end
    end
  end
end
