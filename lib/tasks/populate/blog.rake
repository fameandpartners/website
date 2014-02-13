namespace "db" do
  namespace "populate" do
    desc "do all the blog populate tasks"
    task blog: :environment do
      Rake::Task["db:populate:blog:settings"].execute
      Rake::Task["db:populate:blog:categories"].execute
      Rake::Task["db:populate:blog:posts"].execute
    end

    namespace "blog" do
      desc "populate blog default configuration"
      task settings: :environment do
        create_default_settings
      end

      desc "populate blog cateries"
      task categories: :environment do
        create_default_blog_categories
      end

      desc "fullfill existing categries with some lorem ipsum posts"
      task posts: :environment do
        Blog::Post.destroy_all
        Blog::Category.all.each do |category|
          create_simple_posts_with_photo(category, 2)
          create_simple_posts_with_photo(category, 1, featured: true)
        end
      end
    end
  end
end

def admin
  @admin ||= Spree::Role.where(name: 'admin').first.users.order('id asc').first
end

def create_default_settings
  Blog::Preference.defaults.each do |key, value|
    Blog::Preference.update_preference(key, value)
  end
end

def create_default_blog_categories
  {
    'musings' => 'MUSINGS',
    'trends' => 'TRENDING',
    'style-tips' => 'STYLE TIPS',
    'formal-prep' => 'FORMAL PREP',
    'fan-girling' => 'FAN GIRLING',
    'video' => 'VIDEO'
  }.each do |category_slug, category_name|
    category = Blog::Category.where(slug: category_slug).first_or_initialize
    category.name = category_name
    category.user_id ||= admin.id
    category.save!
  end
end

def create_simple_posts_with_photo(category, size, options = {})
  user = category.user
  size.times do |index|
    post = category.posts.simple_posts.new(
      body: generate_text(200),
      description: generate_text(10),
      user_id: user.id,
      published_at: 1.day.ago
    )
    post.title = generate_text(2)
    post.slug = post.title.gsub(/\W/, '-')
    post.featured_at = 1.day.ago if options[:featured]
    post.occured_at = 3.days.ago
    post.save

    image = post.post_photos.new
    image.user_id = user.id
    image.photo = File.open(File.join(Rails.root, 'app/assets/images/_sample/blog-carousel.jpg'))
    image.save!

    post.update_attribute(:primary_photo_id, image.id)
    post
  end
end

# private
def generate_text(words_num)
  Array.new(words_num) { random_word }.join(' ')
end

def random_word
  random_words[rand(random_words.size)]
end

def random_words
  @random_words ||= [
    "aliquam", "bibendum", "massa", "quis", "placerat", "pharetra", "velit", 
    "posuere", "eleifend", "sapien", "lectus", "purus", "nunc", "egestas",
    "pellentesque", "condimentum", "varius", "augue", "iaculis", "duis",
    "vestibulum", "felis", "lobortis", "lobortis", "etiam", "volutpat",
    "ligula", "quis", "convallis", "viverra", "pellentesque"
  ]
end
