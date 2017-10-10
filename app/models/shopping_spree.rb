class ShoppingSpree
  attr_reader :shopping_spree_id
  
  def initialize( shopping_spree_id )
    @shopping_spree_id = shopping_spree_id
    @firebase = ShoppingSpree.firebase
  end

  def self.create
    ref = self.firebase.push( '', { members: [], chats: [], created_at: Firebase::ServerValue::TIMESTAMP } )
    shopping_spree = ShoppingSpree.new( ref.body['name'] )
    shopping_spree.post_welcome_messages
    
    shopping_spree
  end
  
  def self.firebase
    firebase_url = "https://#{ENV['FIREBASE_DATABASE_NAME']}.firebaseio.com/"
    @firebase = Firebase::Client.new( firebase_url )
  end

  def join( name, email )

    icon = rand( 19 ) + 1
    to_return = { name: name, email: email, icon: icon }
    @firebase.push( "#{@shopping_spree_id}/members", to_return.merge( { created_at: Firebase::ServerValue::TIMESTAMP }) )
    
    post_joined_message( name, email, icon )
    return to_return
  end

  def post_chat_message( message )
    @firebase.push( "#{@shopping_spree_id}/chats", message.merge( { created_at: Firebase::ServerValue::TIMESTAMP } ) )
  end
  
  def post_joined_message( name, email, icon )
    post_chat_message( { type: 'joined', email: email, icon: icon, name: name } )
  end

  def post_dress_message( email, name, icon, product )
    product.extend( PathBuildersHelper )
    color = product.basic_colors.first
    
    post_chat_message(
      {
        type: 'share_dress',
        value:
          {
            name: product.name,
            price: product.price.to_i,
            product_id: product.id,
            url: "/dresses/#{product.descriptive_url( product )}",
            color: {
              id: color.id,
              name: color.name,
              presentation: color.presentation,
              price: 0
            },
            image: "https://d1msb7dh8kb0o9.cloudfront.net/spree/products/35873/original/fprv1026p-black_and_white_spot-front.jpg?1494461867",
            description: product.description,
          },
        from:
          {
            name: email,
            email: name,
            icon: icon,
          }
      }
    )
  end
  
  def post_text_message( email, icon, name, text )
    post_chat_message( { type: 'text',
                         from:
                           {
                             email: email,
                             name: name,
                             icon: icon
                           },
                         value: text
                       }
                     )
  end
  
  
  def post_welcome_messages
    post_text_message( 'help@fameandpartners.com', '20', 'Fame Bot', 'You can post items here and chat with your friends' )
    post_text_message( 'help@fameandpartners.com', '20', 'Fame Bot', 'Here''s something to get you started!' )
    
    post_dress_message( 'help@fameandpartners.com',
                        '20',
                        'Fame Bot',
                        Spree::Product.where( 'name like ?', '%Maritza%' ).first
                      ) 
  end
  
end
