class Blog::RedCarpetPost < ActiveRecord::Base
  attr_accessible :author_id, :body, :category_id, :created_at, :occured_at, :published_at, :title, :updated_at, :user_id
end
