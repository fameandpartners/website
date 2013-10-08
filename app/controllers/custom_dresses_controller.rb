class CustomDressesController < ApplicationController
  before_filter :authenticate_spree_user!
  before_filter :destroy_ghosts, :only => [:step1, :create]

  layout 'spree/layouts/spree_application'

  def step1
    @custom_dress = CustomDress.new(session[:custom_dress] || {})
  end

  def create
    @custom_dress = CustomDress.new(params[:custom_dress])
    @custom_dress.spree_user = current_spree_user

    if @custom_dress.save
      session.delete(:custom_dress)
      redirect_to step2_custom_dress_path(@custom_dress)
    else
      session[:custom_dress] = params[:custom_dress]
      redirect_to :back
    end
  end

  def step2
    @custom_dress = CustomDress.find_ghost_for_user_by_id!(current_spree_user.id, params[:id])

    if session[:custom_dress]
      @custom_dress.assign_attributes(session[:custom_dress])
      @custom_dress.valid?
    end
  end

  def success
    @custom_dress = CustomDress.find_ghost_for_user_by_id!(current_spree_user.id, params[:id])

    @custom_dress.assign_attributes(params[:custom_dress])

    if @custom_dress.save
      @custom_dress.update_column(:ghost, false)
      session.delete(:custom_dress)

      render :success

      Spree::UserMailer.custom_dress_created(@custom_dress).deliver
      Spree::AdminMailer.custom_dress_created(@custom_dress).deliver
    else
      session[:custom_dress] = params[:custom_dress]
      redirect_to :back
    end
  end

  def choose_dress
    @products = Spree::Product.all
  end

  private

  def destroy_ghosts
    CustomDress.destroy_all(:spree_user_id => current_spree_user.id, :ghost => true)
  end

  def colors
    @colors ||= Products::ColorsSearcher.new(@products.to_a).retrieve_colors
  end
  helper_method :colors
end
