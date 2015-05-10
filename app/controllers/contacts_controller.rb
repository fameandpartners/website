class ContactsController < ApplicationController

  layout 'redesign/application'

  def new
    @contact = Contact.new(:site_version => current_site_version.code)
    @title = "Contact - " + default_seo_title
    @description = ""
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      ContactMailer.email(@contact).deliver
      flash[:notice] = "We're on it!"
      redirect_to success_contact_path
    else
      render action: :new
    end
  end
  
  def success
    title('Thank You', default_seo_title)
  end
end
