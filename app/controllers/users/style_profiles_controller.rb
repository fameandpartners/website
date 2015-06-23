class Users::StyleProfilesController < Users::BaseController
  def show
    @style_profile = current_spree_user.style_profile

    if @style_profile.blank?
      redirect_to style_quiz_path  and return
    end

    @products = load_products

    @title = 'My Style Profile'

    respond_with(@style_profile) do |format|
      format.html {}
      format.js   {}
    end
  end

  private
    
    def load_products
      StyleQuiz::ProductsRecommendations.new(
        style_profile: @style_profile
      ).read_all(limit: 12).map do |product|
        Products::Collection::Dress.from_hash(
          id: product.id,
          name: product.name,
          price: Repositories::ProductPrice.new(product: product).read,
          images: Repositories::ProductImages.new(product: product).filter(cropped: true).map(&:large),
          discount: Repositories::Discount.get_product_discount(product.id),
          fast_making: product.fast_making,
          fast_delivery: product.fast_delivery
        )
      end
    end

end
