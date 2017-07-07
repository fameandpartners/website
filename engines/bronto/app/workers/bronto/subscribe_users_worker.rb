module Bronto
  class SubscribeUsersWorker
    include Sidekiq::Worker

    def perform(list_name, users)
      Bronto::SubscribeUsersService.perform(list_name, users)
    end
  end
end
