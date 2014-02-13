require 'ostruct'

module Blog
  def self.table_name_prefix
    'blog_'
  end

  def self.config
    result = OpenStruct.new
    Blog::Preference.all.each do |preference|
      result.send("#{preference.key}=", preference.value)
    end
    result
  end
end
