Spree::Admin::SearchController.class_eval do
  def order_owners
    users = Spree::User.ransack(params[:q]).result.limit(10)

    render json: { users: users }
  end

  def model_class
    Spree::User
  end
end
