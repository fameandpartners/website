Spree::Admin::BannerBoxesController.class_eval do
	def index
		@collection,@collection_small = collection
	end

	protected

	def collection
		return @collection if @collection.present?
		params[:q] ||= {}
		params[:q][:s] ||= "position asc"
		@search = super.ransack(params[:q])
		@collection = @search.result.where("is_small =?",false).page(params[:page]).per(Spree::Config[:admin_products_per_page])
		@collection_small = @search.result.where("is_small =?",true).page(params[:page]).per(Spree::Config[:admin_products_per_page])
		return  @collection, @collection_small
	end

end
