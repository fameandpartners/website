class MoodboardsController < ApplicationController
  before_filter :authenticate_spree_user!

  respond_to :js, :html

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to moodboards_url, alert: "Sorry babe, we couldn't find that, here's your regular wishlist."
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
      render :new
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
    render :show
  end

  def show
    candidate_id = params[:id].to_i
    @resource    = if candidate_id.nonzero?
                     collection.find(candidate_id)
                   else
                     collection.default_or_create
                   end
    @title = @resource.name
  end

  private

  helper_method def collection
    @collection ||= spree_current_user.moodboards
  end

  helper_method def enhanced_moodboards_enabled?
    Features.active?(:enhanced_moodboards)
  end
end
