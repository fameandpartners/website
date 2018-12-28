class ReprocessImageWorker
  include Sidekiq::Worker

  def perform(image_id)
    image = Spree::Image.find(image_id)
    image.attachment.reprocess!

    image.attachment_updated_at = image.attachment_updated_at + 1.second
    image.save!
  end
end
