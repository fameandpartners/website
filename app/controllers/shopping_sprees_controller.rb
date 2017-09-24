class ShoppingSpreesController < ApplicationController
  
  def create()
    if( !params[:email].blank? && !params[:name].blank? )
      shopping_spree = ShoppingSpree.create
      to_return = shopping_spree.join( params[:name ], params[:email] )
      cookies[:shopping_spree_name] = to_return[:name]
      cookies[:shopping_spree_email] = to_return[:email]
      cookies[:shopping_spree_icon] = to_return[:icon]
      cookies[:shopping_spree_id] = shopping_spree.shopping_spree_id
      
      render json: (to_return.merge( { id: shopping_spree.shopping_spree_id } ) ).to_json
    end
  end

  def join
  end
  
end
