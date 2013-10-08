class FameChainsController < ApplicationController
  before_filter :set_seo_meta

  def new
    @fame_chain = FameChain.new
  end

  def create
    @fame_chain = FameChain.new(params[:fame_chain])
    if @fame_chain.send_request
      flash[:notice] = 'Yours request was successfully sent'
      redirect_to success_fame_chain_path
    else
      render action: :new
    end
  end

  private

  def set_seo_meta
    @title = "Join The Fame Chain - Fame & Partners"
  end
end