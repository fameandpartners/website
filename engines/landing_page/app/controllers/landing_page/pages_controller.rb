module LandingPage
  class PagesController < ApplicationController

    def index    
      render :layout => 'landing_page/application'
    end

    def page
      Page.delete_all
      Page.create!(:path => params[:path], :title => 'BlahVtha')
      
      @page ||= Page.where(:path => params[:path]).first
    end

    helper_method :page
  end
end


