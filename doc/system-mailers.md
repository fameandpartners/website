# MarketingMailer

app/views/marketing_mailer/

# Abandoned Cart

order = Spree::Order.joins(:line_items).where("user_id is not null").first
MarketingMailer.abandoned_cart(order, order.user).deliver

# Added Wishlist

user = WishlistItem.last.user
MarketingMailer.added_to_wishlist(user).deliver

# style_quiz_completed

user = UserStyleProfile.last.user
MarketingMailer.style_quiz_completed(user).deliver

# Style Quiz Not Completed

user = Spree::User.last
MarketingMailer.style_quiz_not_completed(user).deliver


# Product Reservations

app/views/product_reservations_mailer/new_reservation.html.slim (and .erb)
reservation = ProductReservation.new(
  user_id: Spree::User.last.id,
  product_id: Spree::Product.last.id,
  school_name: 'Hogwarts',
  school_year: '2015',
  color: 'rainbow'
)
ProductReservationsMailer.new_reservation(reservation).deliver


# Competitions Mailer
app/views/spree/competitions_mailer/

invite = Spree::User.last.invitations.new(
  name: 'harry potter',
  email: 'email@example.com',
  invitation_type: 'personal'
)
invite.token = SecureRandom.urlsafe_base64(nil, false)
Spree::CompetitionsMailer.invite(invite).deliver

Spree::CompetitionsMailer.marketing_email('mail@example.com').deliver


# Send to Friend
app/views/spree/product_mailer/send_to_friend.html.slim
product = Spree::Product.last
info = { sender_name: 'Hogwarts', sender_email: 'sender_email@example.com', email: 'email@example.com'}
Spree::ProductMailer.send_to_friend(product, info).deliver


# User Mailer

app/views/spree/user_mailer/

Spree::UserMailer.welcome(Spree::User.first).deliver

user = Spree::User.first
user.password = '123456'
Spree::UserMailer.welcome(user).deliver

Spree::UserMailer.welcome_to_competition(Spree::User.first).deliver

Spree::UserMailer.reset_password_instructions(Spree::User.first).deliver

user = UserStyleProfile.last.user
Spree::UserMailer.style_profile_created(user).deliver
Spree::UserMailer.style_call_welcome(Spree::User.first).deliver



# Not Used, but Still in Codebase
# Spree::UserMailer.confirmation_instructions(Spree::User.first).deliver
# Spree::UserMailer.custom_dress_created(CustomDress.new).deliver
# Custom Dress Requests

app/views/custom_dresses_mailer/request_custom_dress.text.erb
dress_request = CustomDressRequest.new(
  email: 'some@example.com',
  last_name: 'last_name',
  description: 'description',
  event_date: '31 February 2100'
)
CustomDressesMailer.request_custom_dress(dress_request).deliver


# FameChain
app/views/fame_chain_mailer/fame_chain.text.erb

fame_chain = FameChain.new(
  name: 'myname',
  email: 'mail@example.com',
  blog: 'myblog',
  blog_size: 'great',
  pinterest: 'pin',
  pinterest_size: 'small'
)
FameChainMailer.fame_chain(fame_chain).deliver

# Shipping
shipment = Spree::Shipment.last
Spree::ShipmentMailer.shipped_email(shipment).deliver


# wishlist item added - after 2 days
item = WishlistItem.last
MarketingMailer.wishlist_item_added(item.user, item).deliver

# wishlist item added - after 2 weeks
item = WishlistItem.last
MarketingMailer.wishlist_item_added_reminder(item.user, item).deliver

# style profile reminder - after 1 week
user = UserStyleProfile.last.user
MarketingMailer.style_quiz_completed_reminder(user).deliver
