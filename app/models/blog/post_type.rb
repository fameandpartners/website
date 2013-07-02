class Blog::PostType
  class << self
    def all
      [
        OpenStruct.new(id: Blog::Post::PostTypes::SIMPLE, name: "Post"),
        OpenStruct.new(id: Blog::Post::PostTypes::RED_CARPET, name: "Red Carpet Post")
      ]
    end
  end
end
