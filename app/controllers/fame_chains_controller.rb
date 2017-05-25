class FameChainsController < ApplicationController

  layout 'redesign/application'

  def new
    @fame_chain = FameChain.new
    title('Join The Fame Chain - Fame and Partners', default_seo_title)
    description('Join a network of fashion forward free thinking bloggers and increase your cred through being linked.')
  end

  def create
    @fame_chain = FameChain.new(params[:fame_chain])
    if @fame_chain.valid?
      FameChainMailer.email(@fame_chain).deliver
      render json: { success: true }
    else
      render json: { errors: @fame_chain.errors }
    end
  end
end
