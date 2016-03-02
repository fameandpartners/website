class MoodboardsController < ApplicationController
  before_filter :authenticate_spree_user!

  respond_to :js, :html

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to moodboards_url, alert: "Sorry babe, we couldn't find that, here's your regular moodboard."
  end

  def new
    default_name = if spree_current_user.first_name.present?
      "#{spree_current_user.first_name.titleize}'s Wedding"
                   else
                     "A very Fame Wedding"
                   end

    @resource = collection.weddings.build(name: default_name)
  end

  def create
    @resource = collection.weddings.build(params[:moodboard])
    if @resource.save
      render :show
    else
      render :new, alert: @resource.errors.full_messages
    end
  end

  def edit
    candidate_id = params[:id].to_i
    @resource    = collection.find(candidate_id)
    @title       = @resource.name
  end

  def update
    candidate_id = params[:id].to_i
    @resource = collection.find(candidate_id)
    @resource.update_attributes(params[:moodboard])

    if @resource.save
      render :show
    else
      render :edit
    end
  end

  def index
    @resource   = collection.default_or_create
    @title      = @resource.name
    spree_current_user.update_attributes(active_moodboard_id: @resource.id)
    render :show
  end

  def show
    candidate_id = params[:id].to_i
    @resource = if candidate_id.nonzero?
                     spree_current_user.all_moodboards.detect {|mb| mb.id == candidate_id }
                   else
                     collection.default_or_create
                end
    raise ActiveRecord::RecordNotFound unless @resource.present?
    @title = @resource.name
    spree_current_user.update_attributes(active_moodboard_id: @resource.id)
  end

  private

  helper_method def collection
    @collection ||= spree_current_user.moodboards.by_recent
  end

  helper_method def all_moodboards
    spree_current_user.all_moodboards
  end

  helper_method def moodboard_editable?
    @resource.persisted? && @resource.user == current_spree_user
  end

  helper_method def enhanced_moodboards_enabled?
    Features.active?(:enhanced_moodboards)
  end
end
