class Blog::PostType
  class << self
    def all
      [
        FastOpenStruct.new(id: Blog::Post::PostTypes::SIMPLE, name: "Post"),
        FastOpenStruct.new(id: Blog::Post::PostTypes::RED_CARPET, name: "Red Carpet Post")
      ]
    end
  end
end
