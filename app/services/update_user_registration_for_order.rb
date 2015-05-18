# update order users registrations
# - create user and assign it to order
# - or just assign users attributes to order
#   [ first_name, last_name,
#    #update
#    #successfull?
#    #new_user_created?
#    #user
#
# Services::UpdateUserRegistrationForOrder.new(order, params)
#
module Services; end
class Services::UpdateUserRegistrationForOrder
  def initialize(order, user, params)
    @order = order
    @user = user
    @params = params

    @order.errors.clear
  end

  def update
    create_user if create_user?
    update_order
    @order
  end

  def successfull?
    @order.errors.blank?
  end

  def new_user_created?
    @user && @user.persisted?
  end

  def user
    @user
  end

  private

  def create_user?
    @user.blank? && @params[:create_account] && !Spree::User.where(:email => @order.email).exists?
  end

  def create_user
    @user ||= Spree::User.new(user_params)
    if @user.save
      @order.user = @user
      @order.save(validate: false)
      @order.errors.clear
    else
      @user.errors.messages.each do |field, messages|
        @order.errors.add(field, *messages)
      end
    end
  end

  def update_order
    if order_params_valid?
      @order.user_first_name = order_params[:user_first_name]
      @order.user_last_name = order_params[:user_last_name]
      @order.email = order_params[:email]
      @order.state = 'address'
      @order.save(validate: false)
    end
  end

  def order_params_valid?
    email = order_params[:email]
    error_messages = EmailValidator.new(attributes: order_params).validate_each(@order, :email, email)
    if error_messages.present?
      @order.errors.add(:email, *error_messages)
    end
    @order.errors.add(:first_name, "can't be blank")  if order_params[:user_first_name].blank?
    @order.errors.add(:last_name, "can't be blank")   if order_params[:user_last_name].blank?
    @order.errors.blank?
  end

  def user_params
    @user_params ||= get_user_params
  end

  def order_params
    @order_params ||= get_order_params
  end

  def get_user_params
    {
      first_name: order_params[:user_first_name],
      last_name: order_params[:user_last_name],
      email: order_params[:email],
      password: @params[:order][:password] || @order.number,
      password_confirmation: @params[:order][:password_confirmation] || @order.number,
      skip_welcome_email: true,
      automagically_registered: true
    }
  end

  def get_order_params
    if (address_params = @params[:order][:bill_address_attributes]).present?
      {
        user_first_name: address_params[:firstname],
        user_last_name: address_params[:lastname],
        email: address_params[:email]
      }
    elsif (address_params = @params[:order][:ship_address_attributes]).present?
      {
        user_first_name: address_params[:firstname],
        user_last_name: address_params[:lastname],
        email: address_params[:email]
      }
    else
      {}
    end
  rescue
    # something unexpected
    {}
  end
end
