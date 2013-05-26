class CustomDressesController < ApplicationController
  before_filter :authenticate_spree_user!
  before_filter :destroy_ghosts, :only => [:new, :create]

  layout 'spree/layouts/spree_application'

  def new
    @custom_dress = CustomDress.new

    render :first
  end

  def create
    @custom_dress = CustomDress.new(params[:custom_dress])
    @custom_dress.spree_user = current_spree_user

    if @custom_dress.save
      render :second
    else
      render :first
    end
  end

  def update
    @custom_dress = CustomDress.find_ghost_for_user_by_id!(current_spree_user.id, params[:id])

    @custom_dress.assign_attributes(params[:custom_dress])

    if @custom_dress.save
      @custom_dress.update_column(:ghost, false)

      render :success

      Spree::UserMailer.custom_dress_created(@custom_dress).deliver
      Spree::AdminMailer.custom_dress_created(@custom_dress).deliver
    else
      render :second
    end
  end

  private

  def destroy_ghosts
    CustomDress.destroy_all(:spree_user_id => current_spree_user.id, :ghost => true)
  end
end
