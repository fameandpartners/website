class SendWelcomeEmailWorker
  include Sidekiq::Worker
  sidekiq_options retry: true

  def perform(user_id)
    user = Spree::User.find(user_id)
    tracker = Marketing::CustomerIOEventTracker.new
    tracker.identify_user(user, user.recent_site_version)
    tracker.track(
      user,
      'account_created',
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email
    )
  end
end
