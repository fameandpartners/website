class ContactsController < ApplicationController

  layout 'redesign/application'

  def new
    @contact = Contact.new(:site_version => current_site_version.code)
    title('Contact', default_seo_title)
    @description = ""
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      EmailCapture.new({service: 'mailchimp'}).capture(OpenStruct.new(email:              @contact.email,
                                                                      first_name:         @contact.first_name,
                                                                      last_name:          @contact.last_name,
                                                                      current_sign_in_ip: request.remote_ip,
                                                                      landing_page:       session[:landing_page],
                                                                      utm_params:         session[:utm_params],
                                                                      site_version:       current_site_version.name))
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
