namespace "db" do
  namespace "populate" do
    task moodboard: :environment do
      Spree::Product.all.each do |product|
        add_default_set_of_items_to product
      end
    end
  end
end

def add_default_set_of_items_to(product)
  moodboard = product.moodboard_items
  ensure_moodboard_items_set_exists(moodboard.moodboard, '', 5)
  ensure_moodboard_items_set_exists(moodboard.parfume, 'http://habrahabr.ru')
  ensure_moodboard_items_set_exists(moodboard.song, 'https://soundcloud.com/pedro-noe/game-of-thrones-main-title')  
end

def ensure_moodboard_items_set_exists(scope, content, max_num = 1)
  elements_to_create = (max_num - scope.length)
  if elements_to_create > 0
    elements_to_create.times do
      scope.create(content: content)
    end
  end
end
