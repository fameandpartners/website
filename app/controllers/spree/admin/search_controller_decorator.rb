Spree::Admin::SearchController.class_eval do
  before_filter :normalize_search_params

  def order_owners
    users = Spree::User.ransack(params[:q]).result.limit(10)

    render json: { users: users }
  end

  def model_class
    Spree::User
  end

  private def normalize_search_params
    params[:q] = (params[:q] || {}).each_with_object({}) do |(key, value), hash|
      hash[key] = value.to_s.strip
    end
  end
end
