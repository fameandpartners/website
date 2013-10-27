class EmailMarketing
  def self.send_emails
    # Initiate date time variables
    now = Time.now
    created_before = (configatron.email_marketing.delay_time.abandoned_cart).ago

    # Abandoned Cart: Send email to a user who has added to cart but not purchased within 60min. Only send the email once to user. Display contents of cart with link back to shopping cart page.
    excluded = Spree::Order.
      joins(:line_items).
      where('spree_line_items.created_at > ?', created_before).uniq

    scope = Spree::Order.
      joins(:user).
      joins(:line_items).
      where('spree_line_items.created_at < ?', created_before).
      where('spree_line_items.created_at > spree_users.last_cart_notification_sent_at OR spree_users.last_cart_notification_sent_at IS NULL').
      uniq

    unless excluded.empty?
      scope = scope.where('spree_orders.id NOT IN (?)', excluded.map(&:id))
    end

    scope.each do |order|
      next unless %w(cart address payment).include?(order.state)
      next unless order.user.present?

      order.user.update_column(:last_cart_notification_sent_at, now)

      MarketingMailer.abandoned_cart(order, order.user).deliver
    end

    # Initiate date time variables
    now = Time.now
    created_before = (configatron.email_marketing.delay_time.added_to_wishlist).ago

    # Added to Wishlist: Send email to a user who added something to their wishlist 12 hours after the last addition. Only send the email once to user. Display contents of wishlist, link to home page.
    excluded = Spree::User.
      joins(:wishlist_items).
      where('wishlist_items.created_at > ?', created_before).uniq

    scope = Spree::User.
      joins(:wishlist_items).
      where('wishlist_items.created_at < ?', created_before).
      where('wishlist_items.created_at > spree_users.last_wishlist_notification_sent_at OR spree_users.last_wishlist_notification_sent_at IS NULL').
      uniq

    unless excluded.empty?
      scope = scope.where('spree_users.id NOT IN (?)', excluded.map(&:id))
    end

    scope.each do |user|
      user.update_column(:last_wishlist_notification_sent_at, now)

      MarketingMailer.added_to_wishlist(user).deliver
    end

    # Initiate date time variables
    now = Time.now
    created_before = (configatron.email_marketing.delay_time.quiz_unfinished).ago

    # Send email 12 hours after last Style Quiz interaction when they did not complete it. Only send the email once to user. Display html content and link to website.
    activities = Activity.
      joins(%q(INNER JOIN spree_users ON spree_users.id = activities.actor_id AND activities.actor_type = 'Spree::User')).
      where(activities: { action: 'quiz_started' }).
      where('activities.created_at < ?', created_before).
      where('activities.created_at > spree_users.last_quiz_notification_sent_at OR spree_users.last_quiz_notification_sent_at IS NULL')

    activities.each do |activity|
      next if activity.actor.style_profile.created_at > activity.created_at

      activity.actor.update_column(:last_quiz_notification_sent_at, now)

      MarketingMailer.style_quiz_not_completed(activity.actor).deliver
    end
  end
end
