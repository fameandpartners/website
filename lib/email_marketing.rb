class EmailMarketing
  def self.send_emails
    send_abandoned_cart_emails
    send_style_quiz_not_completed_emails

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
    codes = %w{style_quiz_completed_reminder}
    #sent_before = (configatron.email_marketing.store_information || 1.month).ago
    #EmailNotification.delete_all(["created_at < ?", sent_before])
    EmailNotification.delete_all(created_at: nil, code: codes)
  end

  # Abandoned Cart: Send email to a user who has added to cart
  # but not purchased within 60min. Only send the email once to user.
  # Display contents of cart with link back to shopping cart page.
  def self.send_abandoned_cart_emails
    # Initiate date time variables
    created_before = (configatron.email_marketing.delay_time.abandoned_cart || 4.hours).ago

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

end
