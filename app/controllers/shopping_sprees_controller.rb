class ShoppingSpreesController < ApplicationController
  
  def create()
    if( !params[:email].blank? && !params[:name].blank? )
      shopping_spree = ShoppingSpree.create
      to_return = shopping_spree.join( params[:email], params[:name ] )
      cookies[:shopping_spree_name] = params[:name]
      cookies[:shopping_spree_email] = params[:email]
      cookies[:shopping_spree_id] = shopping_spree.shopping_spree_id
      
      render json: (to_return.merge( { id: shopping_spree.shopping_spree_id } ) ).to_json
    end
  end
end
