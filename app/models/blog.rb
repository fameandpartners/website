require 'ostruct'

module Blog
  def self.table_name_prefix
    'blog_'
  end

  def self.config
    result = FastOpenStruct.new
    Blog::Preference.all.each do |preference|
      if preference.value.present?
        result.send("#{preference.key}=", preference.value)
      end
    end
    result
  end
end
