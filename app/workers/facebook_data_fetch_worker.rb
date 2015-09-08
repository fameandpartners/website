class FacebookDataFetchWorker
  include Sidekiq::Worker
  sidekiq_options retry: true

  def perform(user_id, uid, token)
    user = Spree::User.find_by_id(user_id)

    return if user.blank?

    fetcher = Facebook::DataFetcher.new(uid, token)

    birthday = fetcher.fetch_birthday

    if birthday.present?
      user.update_column(:birthday, birthday)
    end

    if (friends = fetcher.fetch_friends)
      user.facebook_data[:friends] = friends
      user.save
    end

    if (gender = fetcher.fetch_gender)
      user.facebook_data[:gender] = gender
      user.save
    end
  end
end
