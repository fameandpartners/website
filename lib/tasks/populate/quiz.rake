namespace :db do
  namespace :populate do
    desc 'Create default quiz'
    task :quiz => :environment do
      quiz = Quiz.create!(:name => 'Style Quiz')

      quiz.questions.create!([
                               {
                                 :text => "Choose the look that's closest to your everyday style?",
                                 :step => 1,
                                 :position => 1001,
                                 :partial => 'outfits'
                               }, {
                                 :text => "You're walking the red carpet. Which dress would you wear?",
                                 :step => 2,
                                 :position => 1002,
                                 :partial => 'oscar_dresses'
                               }, {
                                 :text => "It's time to dress up. Which best describes your style.",
                                 :step => 3,
                                 :position => 1003,
                                 :multiple => true,
                                 :partial => 'style_words'
                               }, {
                                 :text => 'Tell us which makeup look you love.',
                                 :step => 4,
                                 :position => 1004,
                                 :partial => 'prom_makeup'
                               }, {
                                 :text => 'Whether it works for you or not, which hair style do you love?',
                                 :step => 5,
                                 :position => 1005,
                                 :partial => 'prom_hair'
                               }, {
                                 :text => 'Which of these runway looks would inspire your dream formal dress?',
                                 :step => 6,
                                 :position => 1006,
                                 :partial => 'prom_dresses'
                               }, {
                                 :text => 'How important is fashion to you?',
                                 :step => 7,
                                 :position => 1007,
                                 :partial => 'fashionability'
                               }, {
                                 :text => 'Do you prefer to show some skin or to cover up? Rank how sexy you like to look.',
                                 :step => 8,
                                 :position => 1008,
                                 :partial => 'sexiness'
                               }, {
                                 :text => 'What is your hair colour?',
                                 :step => 9,
                                 :position => 1008,
                                 :partial => 'hair_colours',
                                 :populate => 'hair_colour'
                               }, {
                                 :text => 'What is your skin colour?',
                                 :step => 9,
                                 :position => 1009,
                                 :partial => 'skin_colours',
                                 :populate => 'skin_colour'
                               }, {
                                 :text => 'What is your body shape?',
                                 :step => 9,
                                 :position => 1010,
                                 :partial => 'body_shapes',
                                 :populate => 'body_shape'
                               }
                             ])

      question = quiz.questions.find_by_partial!('outfits')
      question.answers.create!([
                                 {
                                   :code => 'img1',
                                   :glam => 10
                                 }, {
                                   :code => 'img2',
                                   :classic => 10
                                 }, {
                                   :code => 'img3',
                                   :girly => 10
                                 }, {
                                   :code => 'img4',
                                   :bohemian => 10
                                 }, {
                                   :code => 'img5',
                                   :edgy => 10
                                 }
                               ])

      question = quiz.questions.find_by_partial!('oscar_dresses')
      question.answers.create!([
                                 {
                                   :code => 'img1',
                                   :glam => 10
                                 }, {
                                   :code => 'img2',
                                   :classic => 10
                                 }, {
                                   :code => 'img3',
                                   :girly => 10
                                 }, {
                                   :code => 'img4',
                                   :bohemian => 10
                                 }, {
                                   :code => 'img5',
                                   :edgy => 10
                                 }
                               ])

      question = quiz.questions.find_by_partial!('style_words')
      question.answers.create!([
                                 {
                                   :code => 'edgy',
                                   :edgy => 10
                                 }, {
                                   :code => 'conservative',
                                   :classic => 10
                                 }, {
                                   :code => 'bohemian',
                                   :bohemian => 10
                                 }, {
                                   :code => 'emo',
                                   :edgy => 10
                                 }, {
                                   :code => 'earthy',
                                   :bohemian => 10
                                 }, {
                                   :code => 'glamorous',
                                   :glam => 10
                                 }, {
                                   :code => 'high_fashion',
                                   :glam => 10
                                 }, {
                                   :code => 'classic',
                                   :classic => 10
                                 }, {
                                   :code => 'bold',
                                   :edgy => 10
                                 }, {
                                   :code => 'sophisticated',
                                   :glam => 10
                                 }, {
                                   :code => 'grown_up',
                                   :classic => 10
                                 }, {
                                   :code => 'girly',
                                   :girly => 10
                                 }, {
                                   :code => 'feminine',
                                   :girly => 10
                                 }, {
                                   :code => 'elegant',
                                   :classic => 10
                                 }, {
                                   :code => 'hot',
                                   :glam => 10
                                 }, {
                                   :code => 'sweet',
                                   :girly => 10
                                 }, {
                                   :code => 'structured',
                                   :glam => 3,
                                   :edgy => 3,
                                   :classic => 3
                                 }, {
                                   :code => 'relaxed',
                                   :glam => 3,
                                   :bohemian => 3,
                                   :classic => 3
                                 }, {
                                   :code => 'understated',
                                   :glam => 2,
                                   :girly => 2,
                                   :bohemian => 2,
                                   :classic => 2
                                 }, {
                                   :code => 'cool',
                                   :bohemian => 5,
                                   :edgy => 5
                                 }
                               ])

      question = quiz.questions.find_by_partial!('prom_makeup')
      question.answers.create!([
                                 {
                                   :code => 'natural',
                                   :glam => 8,
                                   :classic => 2
                                 }, {
                                   :code => 'dramatic',
                                   :edgy => 6,
                                   :bohemian => 2
                                 }, {
                                   :code => 'romantic',
                                   :girly => 5,
                                   :glam => 7,
                                   :classic => 5
                                 }, {
                                   :code => 'statement',
                                   :bohemian => 10
                                 }, {
                                   :code => 'edgy',
                                   :edgy => 5,
                                   :glam => 3,
                                   :bohemian => 3
                                 }
                               ])

      question = quiz.questions.find_by_partial!('prom_hair')
      question.answers.create!([
                                 {
                                   :code => 'glam',
                                   :glam => 10
                                 }, {
                                   :code => 'classic',
                                   :classic => 10
                                 }, {
                                   :code => 'girly',
                                   :girly => 10
                                 }, {
                                   :code => 'bohemian',
                                   :bohemian => 10
                                 }, {
                                   :code => 'edgy',
                                   :edgy => 10
                                 }
                               ])

      question = quiz.questions.find_by_partial!('prom_dresses')
      question.answers.create!([
                                 {
                                   :code => 'glam',
                                   :glam => 10
                                 }, {
                                   :code => 'classic',
                                   :classic => 10
                                 }, {
                                   :code => 'girly',
                                   :girly => 10
                                 }, {
                                   :code => 'boho',
                                   :bohemian => 10
                                 }, {
                                   :code => 'edgy',
                                   :edgy => 10
                                 }
                               ])

      question = quiz.questions.find_by_partial!('fashionability')
      question.answers.create!([
                                 {
                                   :code => 'fsh1',
                                   :fashionability => 1
                                 }, {
                                   :code => 'fsh2',
                                   :fashionability => 2
                                 }, {
                                   :code => 'fsh3',
                                   :fashionability => 3
                                 }, {
                                   :code => 'fsh4',
                                   :fashionability => 4
                                 }, {
                                   :code => 'fsh5',
                                   :fashionability => 5
                                 }, {
                                   :code => 'fsh6',
                                   :fashionability => 6
                                 }, {
                                   :code => 'fsh7',
                                   :fashionability => 7
                                 }, {
                                   :code => 'fsh8',
                                   :fashionability => 8
                                 }, {
                                   :code => 'fsh9',
                                   :fashionability => 9
                                 }, {
                                   :code => 'fsh10',
                                   :fashionability => 10
                                 }
                               ])

      question = quiz.questions.find_by_partial!('sexiness')
      question.answers.create!([
                                 {
                                   :code => 'sxs1',
                                   :sexiness => 1
                                 }, {
                                   :code => 'sxs2',
                                   :sexiness => 2
                                 }, {
                                   :code => 'sxs3',
                                   :sexiness => 3
                                 }, {
                                   :code => 'sxs4',
                                   :sexiness => 4
                                 }, {
                                   :code => 'sxs5',
                                   :sexiness => 5
                                 }, {
                                   :code => 'sxs6',
                                   :sexiness => 6
                                 }, {
                                   :code => 'sxs7',
                                   :sexiness => 7
                                 }, {
                                   :code => 'sxs8',
                                   :sexiness => 8
                                 }, {
                                   :code => 'sxs9',
                                   :sexiness => 9
                                 }, {
                                   :code => 'sxs10',
                                   :sexiness => 10
                                 }
                               ])

      question = quiz.questions.find_by_partial!('hair_colours')
      question.answers.create!([
                                 {
                                   :code => 'black'
                                 }, {
                                   :code => 'brunette'
                                 }, {
                                   :code => 'auburn'
                                 }, {
                                   :code => 'blonde'
                                 }, {
                                   :code => 'platinum_blonde'
                                 }, {
                                   :code => 'strawberry_blonde'
                                 }, {
                                   :code => 'red'
                                 }, {
                                   :code => 'coloured'
                                 }
                               ])

      question = quiz.questions.find_by_partial!('skin_colours')
      question.answers.create!([
                                 {
                                   :code => 'fair'
                                 }, {
                                   :code => 'medium_fair'
                                 }, {
                                   :code => 'medium'
                                 }, {
                                   :code => 'medium_dark'
                                 }, {
                                   :code => 'dark'
                                 }
                               ])

      question = quiz.questions.find_by_partial!('body_shapes')
      question.answers.create!([
                                 {
                                   :code => 'apple'
                                 }, {
                                   :code => 'pear'
                                 }, {
                                   :code => 'athletic'
                                 }, {
                                   :code => 'strawberry'
                                 }, {
                                   :code => 'hour_glass'
                                 }, {
                                   :code => 'column'
                                 }, {
                                   :code => 'petite'
                                 }
                               ])
    end
  end
end
