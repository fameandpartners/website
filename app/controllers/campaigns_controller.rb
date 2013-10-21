class CampaignsController < ApplicationController
  layout 'statics'

  def show
    render 'stylecall'
  end

  def create
    if spree_user_signed_in?
      @user = try_spree_current_user
      @user.validate_presence_of_phone = true
      @user.phone = params[:user][:phone]
      @user.save
    else
      @user = Spree::User.create_user(params[:user].extract!(:email, :first_name, :last_name, :phone).merge(sign_up_reason: 'campaign_style_call', validate_presence_of_phone: true))
      @just_registered = true
    end

    if !@user.persisted? || @user.errors.present?
      render 'stylecall'
    else
      if @just_registered
        sign_in(:spree_user, @user)
        Spree::UserMailer.style_call_welcome(@user).deliver
      end
      Spree::AdminMailer.stylist_consultation_requested(@user).deliver
      session['just_registered'] = @just_registered
      session['stylist_consultation_just_requested'] = true

      redirect_to campaigns_stylecall_thankyou_path
    end
  end

  def thank_you
    unless (spree_user_signed_in? && session.delete('stylist_consultation_just_requested'))
      redirect_to campaigns_stylecall_path
    end

    @just_registered = session.delete('just_registered')


    @products = Spree::Product.first(3)
    @colors = Products::ColorsSearcher.new(@products.to_a).retrieve_colors
  end

  def dolly
    @participation = Participation.new(params[:participation])

    if @participation.valid?
      CampaignMonitor.delay.synchronize(@participation.email, nil, Signupreason: 'Dolly campaign')
    end
  end

  def newsletter
    @participation = Participation.new(params[:participation])

    if @participation.valid?
      CampaignMonitor.delay.synchronize(@participation.email, nil, Signupreason: 'Newsletter Modal')
    end
  end
end
