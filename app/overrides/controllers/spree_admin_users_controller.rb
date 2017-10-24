Spree::Admin::UsersController.class_eval do
  before_filter :clear_params, only: [:update]

  # def update
  #   binding.pry
  #   @user.email = params[:user]['email'].downcase
  #   @user.first_name = params[:user]['first_name']
  #   @user.last_name = params[:user]['first_name']
  #   @user.last_name = params[:user]['last_name']
  #   if params[:user][:password].present?
  #     user = Spree::User.reset_password_by_token(params[:user])
  #   end

  #   params[:user]['spree_role_ids'].each do |role_id|
  #     unless role_id.empty?
  #       role = Spree::Role.find(role_id)
  #       @user.spree_roles << role
  #     end
  #   end
  #   render :edit
  # end

  
  def update 
    if params[:user]
       roles = params[:user].delete("spree_role_ids")
    end
    params[:user][:email] = params[:user][:email].downcase
    if @user.update_attributes(params[:user])
       if roles
         @user.spree_roles = roles.reject(&:blank?).collect{|r| Spree::Role.find(r)}
       end
       flash.now[:success] = Spree.t(:account_updated)
       render :edit
     else
      render :edit
    end
  end

  private


  # XXX: this is a hack for devise that removes empty password and password confirmation
  # values in order to save user without password change
  def clear_params
    if params[:user].present? && !params[:user][:password].nil?
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
    end
  end
end
