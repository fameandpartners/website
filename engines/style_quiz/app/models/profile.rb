class StyleQuiz::Profile
  attr_accessor :fullname,
    :email,
    :birthdate,
    :hair_color,
    :eyes_color,
    :body_sizes,
    :body_shapes,
    :fashion_importance,
    :sexyness_importance,
    :events
    :tags
end


class StyleQuiz::Tag
  groups: [
    'color', 'pattern', 'fabric', 'style', 'feature', 'trends'
  ]
end
