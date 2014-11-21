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

    friends = fetcher.fetch_friends

    if friends.present?
      user.facebook_datas.create do |record|
        record.value = friends
      end
    end
  end
end
