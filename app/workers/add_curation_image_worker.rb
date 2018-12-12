class AddCurationImageWorker
  include Sidekiq::Worker

  def perform(image_url, position, curation_id)
    Dir.mktmpdir do |dir|
      file_name = URI(image_url).path.gsub('/', '~').gsub(/^~/, '')

      attachment_tmp = open(image_url)
      attachment = File.new(File.join(dir, file_name), 'w+')
      attachment.binmode
      attachment.write attachment_tmp.read
      attachment.flush
      attachment.seek(0)

      spree_image = Spree::Image.find_or_create_by_viewable_type_and_viewable_id_and_attachment_file_name('Curation', curation_id, file_name)
      spree_image.attachment = attachment
      spree_image.position = position
      spree_image.save!
    end
  end
end
