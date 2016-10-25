class ContactsController < ApplicationController

  layout 'redesign/application'

  def new
    @contact = Contact.new(site_version: current_site_version.code)
    title('Contact', default_seo_title)
    description('Contact the Fame and Partners customer service department or find the answers to our Frequently Asked Questions.');
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      ContactMailer.email(@contact).deliver
      redirect_to success_contact_path, notice: "We're on it!"
    else
      render action: :new
    end
  end

  def join_team
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      ContactMailer.join_team(@contact).deliver
      redirect_to success_contact_path, notice: "We're on it!"
    else
      render 'statics/about'
    end
  end

  def success
    title('Thank You', default_seo_title)
  end
end
