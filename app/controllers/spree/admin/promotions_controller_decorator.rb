Spree::Admin::PromotionsController.class_eval do
  def collection
    @collection = super
    @collection
      .order('created_at DESC')
      .page(params[:page])
  end
end
