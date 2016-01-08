module Moodboards
  class WeddingsController < ApplicationController

    layout false

    private def search_scope
      spree_current_user.moodboards.weddings
    end

    private def wedding_name(name)
      "#{name.to_s.titleize}'s Wedding"
    end

    private def default_wedding_moodboard
      default_name = if spree_current_user.first_name.present?
                       wedding_name(spree_current_user.first_name)
                     else
                       "Wedding"
                     end

      moodboard = search_scope.first

      unless moodboard
        moodboard = search_scope.create(name: default_name)
      end
      moodboard
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
        render :guests
      else
        render :edit
      end
    end
  end
end
