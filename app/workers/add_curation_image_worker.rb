class AddCurationImageWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'image_processing'

  def perform(image_url, position, curation_id)
    Dir.mktmpdir do |dir|
      file_name = URI(image_url).path.gsub('/', '~').gsub(/^~/, '').gsub('~', '_').gsub('.jpeg', '.jpg')

      puts "---------------"
      puts image_url
      puts position
      puts curation_id
      attachment_tmp = open(image_url)
      puts "***************"
      attachment = File.new(File.join(dir, file_name), 'w+')
      attachment.binmode
      attachment.write attachment_tmp.read
      attachment.flush
      attachment.seek(0)

      spree_image = Spree::Image.find_or_initialize_by_viewable_type_and_viewable_id_and_attachment_file_name('Curation', curation_id, file_name)
      spree_image.attachment = attachment
      spree_image.position = position
      spree_image.save!

      puts "file name:"
      puts File.join(dir, file_name)
      attachment.close
      File.delete(File.join(dir, file_name))
    end
  end
end
