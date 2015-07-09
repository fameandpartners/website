=begin
  load File.join(StyleQuiz::Engine.root, 'elastic.rb')
=end

def query
  Tire.search('style_quiz_products_profiles_index', size: 1) do
    filter :exists, :field => :id

    script_field :score, script: %q{ 
        _source.tags
        doc['id'].value + index;
      },
      params: { index: 1 }

    #script_field :tags, script: %q{ doc['tags'].values[0] }
  end
end

def query(profile_tags = { 143 => 1, 176 => 10 })
  tags = []
  profile_tags.each do |tag_id, weight|
    tags.push({ id: tag_id, weight: weight })
  end

  Tire.search('style_quiz_products_profiles_index', size: 1) do
    filter :bool, :must => { :term => { :id => 536 }}

    script_field :relevance, script: %q<
      result = 0;
      if (_source.containsKey('tags')) {
        foreach( product_tag : _source['tags'] ) {
          foreach ( profile_tag : profile_tags ){
            if (profile_tag.id == product_tag.id) {
              result = result + profile_tag.weight * product_tag.weight
            }
          }
        }
      }
      return result;
    >.gsub(/[\r\n]|([\s]{2,})/, ''),
    params: { profile_tags: tags }
  end
end
