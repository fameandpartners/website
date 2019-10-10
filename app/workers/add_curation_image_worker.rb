class AddCurationImageWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'image_processing'

  def perform(image_url, position, curation_id)
    Dir.mktmpdir do |dir|
      file_name = URI(image_url).path.gsub('/', '~').gsub(/^~/, '').gsub('~', '_').gsub('.jpeg', '.jpg')

      puts File.join(dir, file_name)
      puts "begin open------------------------"
      puts image_url
      puts position
      puts curation_id
      attachment_tmp = open(image_url)
      puts "end open**************************"

      attachment = File.new(File.join(dir, file_name), 'w+')
      attachment.binmode
      attachment.write attachment_tmp.read
      attachment.flush
      attachment.seek(0)
      puts "~~~~~~~~~~~~~~~~~~~~~~~~"
      spree_image = Spree::Image.find_or_initialize_by_viewable_type_and_viewable_id_and_attachment_file_name('Curation', curation_id, file_name)

      puts spree_image
      spree_image.attachment = attachment
      spree_image.position = position
      spree_image.save!

      puts "begin delete file"
      attachment.close
      puts "close done"
      File.delete(File.join(dir, file_name))
      puts "end delete file"
    end
  end
end
