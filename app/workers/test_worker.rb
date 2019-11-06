class TestWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'image_processing'

  def perform(text)
    puts "perform test work start"
    sleep(10)
    puts "perform test work end"
  end
end
