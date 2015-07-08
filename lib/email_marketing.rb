class EmailMarketing
  def self.send_emails
    # send_abandoned_cart_emails
    send_style_quiz_not_completed_emails

    # Added to Wishlist: Send email to a user who added something
    # to their wishlist 12 hours after the last addition.
    # Only send the email once to user. Display contents of wishlist, link to home page.
    #send_added_to_wishlist_emails # updated

    # Business Rule: Goes out 2 days after added to wishlist
    # send_wishlist_item_added

    # Business rule: Goes out 2 weeks after added to wishlist, if they have not purchased
    # send_wishlist_item_added_reminder

    #Email: Goes out 1 week after style profile complete
    send_style_quiz_completed_reminder_emails

    # clear information about old email notifications, sent month ago or later
    remove_old_notifications
  end

  private

  def self.not_later_than
    2.weeks
  end

  def self.remove_old_notifications
    codes = %w{style_quiz_completed_reminder wishlist_item_added_reminder wishlist_item_added}
    #sent_before = (configatron.email_marketing.store_information || 1.month).ago
    #EmailNotification.delete_all(["created_at < ?", sent_before])
    EmailNotification.delete_all(created_at: nil, code: codes)
  end

  # Abandoned Cart: Send email to a user who has added to cart
  # but not purchased within 60min. Only send the email once to user.
  # Display contents of cart with link back to shopping cart page.
  def self.send_abandoned_cart_emails
    # Initiate date time variables
    created_before = (configatron.email_marketing.delay_time.abandoned_cart || 1.hour).ago

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
      AbandonedCartEmailWorker.perform_async(order.id)
    end
  end

  # Added to Wishlist: Send email to a user who added something
  # to their wishlist 12 hours after the last addition.
  # Only send the email once to user. Display contents of wishlist, link to home page.
  def self.send_added_to_wishlist_emails
    # Initiate date time variables
    now = Time.now
    created_before = (configatron.email_marketing.delay_time.added_to_wishlist || 12.hours).ago

    scope = Spree::User.
      joins(:wishlist_items).
      where('wishlist_items.created_at < ?', created_before).
      where('wishlist_items.created_at > spree_users.last_wishlist_notification_sent_at OR spree_users.last_wishlist_notification_sent_at IS NULL').
      uniq

    excluded = Spree::User.
      joins(:wishlist_items).
      where('wishlist_items.created_at > ?', created_before).uniq

    unless excluded.empty?
      scope = scope.where('spree_users.id NOT IN (?)', excluded.map(&:id))
    end

    scope.each do |user|
      AddedToWishlistEmailWorker.perform_async(user.id)
    end
  end

  # Send email 12 hours after last Style Quiz interaction when they did not complete it.
  # Only send the email once to user. Display html content and link to website.
  def self.send_style_quiz_not_completed_emails
    # Initiate date time variables
    now = Time.now
    created_before = (configatron.email_marketing.delay_time.quiz_unfinished || 12.hours).ago

    activities = Activity.
      joins(%q(INNER JOIN spree_users ON spree_users.id = activities.actor_id AND activities.actor_type = 'Spree::User')).
      where(activities: { action: 'quiz_started' }).
      where('activities.created_at < ?', created_before).
      where('activities.created_at > spree_users.last_quiz_notification_sent_at OR spree_users.last_quiz_notification_sent_at IS NULL')

    actor_ids = []
    activities.each do |activity|
      next if activity.actor.blank? || activity.actor.style_profile.blank?
      next if activity.actor.style_profile.created_at > activity.created_at
      actor_ids.push(activity.actor_id)
    end

    actor_ids.compact.uniq.each do |user_id|
      StyleQuizNotCompletedEmailWorker.perform_async(user_id)
    end
  end

  # Email: Goes out 1 week after style profile complete
  # note - about 500 profiles created per week.
  def self.send_style_quiz_completed_reminder_emails
    code = 'style_quiz_completed_reminder'
    created_before  = (configatron.email_marketing.delay_time.style_profile_completed_reminder || 1.week).ago
    created_after   = self.not_later_than.ago

    already_received = EmailNotification.where(
      "code = ? and created_at > ?", code, created_after
    ).map(&:spree_user_id)
    profiles_scope = UserStyleProfile.where(["created_at > ? and created_at < ?", created_after, created_before])
    if already_received.present?
      profiles_scope = profiles_scope.where("user_id not in (?)", already_received)
    end
    profiles_scope.each do |profile|
      StyleQuizCompletedReminderEmailWorker.perform_async(profile.id)
    end
  end

  # Business Rule: Goes out 2 days after added to wishlist
  # 300 records for 12 days
  def self.send_wishlist_item_added
    code = 'wishlist_item_added'
    created_before  = (configatron.email_marketing.delay_time.wishlist_item_added || 48.hours).ago
    created_after   = self.not_later_than.ago

    already_received = EmailNotification.select('distinct(spree_user_id)').where(
      "code = ? and created_at > ?", code, created_after
    ).map(&:spree_user_id)

    items_scope = WishlistItem.includes(:user).where(["created_at > ? and created_at < ?", created_after, created_before])
    if already_received.present?
      items_scope = items_scope.where("spree_user_id not in (?)", already_received)
    end
    items_scope.each do |item|
      if item.user.can_receive_email_marketing_notification?(code)
        WishlistItemAddedEmailWorker.perform_async(item.id)
      end
    end
  end

  # Business rule: Goes out 2 weeks after added to wishlist, if they have not purchased
  def self.send_wishlist_item_added_reminder
    code = 'wishlist_item_added_reminder'
    created_before  = (configatron.email_marketing.delay_time.wishlist_item_added_reminder || 2.weeks).ago
    created_after   = (configatron.email_marketing.store_information || 1.month).ago

    already_received = EmailNotification.where(
      "code = ? and created_at > ? and created_at < ?", code, created_after, created_before
    ).map(&:spree_user_id)

    items_scope = WishlistItem.includes(:user).where(["created_at > ? and created_at < ?", created_after, created_before])
    if already_received.present?
      items_scope = items_scope.where("spree_user_id not in (?)", already_received)
    end
    items_scope.each do |item|
      if item.user.can_receive_email_marketing_notification?(code)
        WishlistItemAddedReminderEmailWorker.perform_async(item.id)
      end
    end
  end

=begin
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
=end
end
