## Other Transactional Emails:

- MailGun
  - contact email
    - event: user submit contact form on the website (`/contact/new`)
    - to: `team@fameandpartners.com`
    - sample subject: `[US] Change Existing Order`
  - join_team
      - event: user submit talent form on the website (`/about`)
      - to: `talent@fameandpartners.com`
      - sample subject: `[US] Join team`
  - shipped email
    - event: an (completed) order was shipped
    - to: order's email
    - sample subject: `Hey babe, your dress is on its way - Order: #R123456`
    - template: `/app/views/spree/shipment_mailer/shipped_email.html.slim`
  - order return request email
    - event: return request is created by the user
    - to: `team@fameandpartners.com`
    - sample subject: `[Order Return Request] R123456`
  - password reset email
    - event: user reset her password
    - to: user's email
    - sample subject: `Password Reset Instructions`
    - template: `/app/views/spree/user_mailer/reset_password_instructions.html.slim`
- Customer.io
  - Note 1: templates are on customer.io
  - Note 2: events not necessarily will send emails. Those are configured on customer.io
  - `email_capture_modal`
    - event: user subscribe on email capturing modal
  - `auto_apply_coupon`
    - event: various reasons, but users triggers this event when eligible for promotions that apply automatically (e.g. facebook login)
  - `wedding_moodboard_update`
    - event: user update the wedding moodboard
  - `email_reminder_promo`
    - event: user login with facebook via promotional pages (has `email_reminder_promo` on their session)
  - `abandoned_cart`
    - event: triggers from time to time for users that have pending cart items for more than 4 hours
  - `order_confirmation_email`
    - event: user completes an order
  - `order_team_confirmation_email`
    - event: user completes an order
  - `invited_to_moodboard`
    - event: user is invited to a moodboard
  - `order_cancel_email`
    - event: user cancel an order
  - `account_created`
    - event: user signs up
  - `order_production_order_email`
    - event: user completes an order

## MarketingMailer

app/views/marketing_mailer/

## Abandoned Cart

order = Spree::Order.joins(:line_items).where("user_id is not null").first
MarketingMailer.abandoned_cart(order, order.user).deliver

## Added Wishlist (Deprecated)(Requires adaptation to MoodboardItem usage)

user = WishlistItem.last.user
MarketingMailer.added_to_wishlist(user).deliver

## style_quiz_completed

user = UserStyleProfile.last.user
MarketingMailer.style_quiz_completed(user).deliver

## Style Quiz Not Completed

user = Spree::User.last
MarketingMailer.style_quiz_not_completed(user).deliver


## Product Reservations

app/views/product_reservations_mailer/new_reservation.html.slim (and .erb)
reservation = ProductReservation.new(
  user_id: Spree::User.last.id,
  product_id: Spree::Product.last.id,
  school_name: 'Hogwarts',
  school_year: '2015',
  color: 'rainbow'
)
ProductReservationsMailer.new_reservation(reservation).deliver


## Competitions Mailer
app/views/spree/competitions_mailer/

invite = Spree::User.last.invitations.new(
  name: 'harry potter',
  email: 'email@example.com',
  invitation_type: 'personal'
)
invite.token = SecureRandom.urlsafe_base64(nil, false)
Spree::CompetitionsMailer.invite(invite).deliver

Spree::CompetitionsMailer.marketing_email('mail@example.com').deliver


## Send to Friend
app/views/spree/product_mailer/send_to_friend.html.slim
product = Spree::Product.last
info = { sender_name: 'Hogwarts', sender_email: 'sender_email@example.com', email: 'email@example.com'}
Spree::ProductMailer.send_to_friend(product, info).deliver


## User Mailer

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

## Spree::UserMailer.confirmation_instructions(Spree::User.first).deliver

## Spree::UserMailer.custom_dress_created(CustomDress.new).deliver

## Custom Dress Requests

app/views/custom_dresses_mailer/request_custom_dress.text.erb
dress_request = CustomDressRequest.new(
  email: 'some@example.com',
  last_name: 'last_name',
  description: 'description',
  event_date: '31 February 2100'
)
CustomDressesMailer.request_custom_dress(dress_request).deliver

## Shipping

shipment = Spree::Shipment.last
Spree::ShipmentMailer.shipped_email(shipment).deliver


## wishlist item added - after 2 days (Deprecated)(Requires adaptation to MoodboardItem usage)
item = WishlistItem.last
MarketingMailer.wishlist_item_added(item.user, item).deliver

## wishlist item added - after 2 weeks (Deprecated)(Requires adaptation to MoodboardItem usage)
item = WishlistItem.last
MarketingMailer.wishlist_item_added_reminder(item.user, item).deliver

## style profile reminder - after 1 week
user = UserStyleProfile.last.user
MarketingMailer.style_quiz_completed_reminder(user).deliver
