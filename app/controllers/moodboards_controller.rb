class MoodboardsController < ApplicationController
  before_filter :authenticate_spree_user!
  # before_filter :load_user

  layout 'redesign/application'

  respond_to :js, :html

  def index
    @collection = spree_current_user.pinboards
    @resource   = @collection.default_or_create

    render :show
  end

  def show
    @collection = spree_current_user.pinboards
    candidate_id = params[:id].to_i
    @resource = if candidate_id.nonzero?
      begin
        @collection.find(candidate_id)
      # rescue ActiveRecord::RecordNotFound
        # @collection.default_or_create
      end
    else
      @collection.default_or_create
    end
  end

  private

  def load_user
    @user = try_spree_current_user
    @user.clean_up_passwords if @user.respond_to?(:clean_up_passwords)
  end
end
