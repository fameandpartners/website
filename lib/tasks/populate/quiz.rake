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
                                 :multiple => true,
                                 :partial => 'outfits'
                               }, {
                                 :text => "You're walking the red carpet. Which dress would you wear?",
                                 :step => 2,
                                 :position => 1002,
                                 :multiple => true,
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
                                 :multiple => true,
                                 :partial => 'prom_makeup'
                               }, {
                                 :text => 'Whether it works for you or not, which hair style do you love?',
                                 :step => 5,
                                 :position => 1005,
                                 :multiple => true,
                                 :partial => 'prom_hair'
                               }, {
                                 :text => 'Which of these runway looks would inspire your dream prom dress?',
                                 :step => 6,
                                 :position => 1006,
                                 :multiple => true,
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
                                   :code => 'boho1',
                                   :bohemian => 9,
                                   :classic => 2,
                                   :edgy => 5,
                                   :girly => 4,
                                   :glam => 2
                                 }, {
                                   :code => 'boho2',
                                   :bohemian => 9,
                                   :classic => 2,
                                   :edgy => 3,
                                   :girly => 6,
                                   :glam => 6
                                 }, {
                                   :code => 'boho3',
                                   :bohemian => 9,
                                   :classic => 2,
                                   :edgy => 3,
                                   :girly => 4,
                                   :glam => 3
                                 }, {
                                   :code => 'boho4',
                                   :bohemian => 9,
                                   :classic => 2,
                                   :edgy => 5,
                                   :girly => 4,
                                   :glam => 3
                                 }, {
                                   :code => 'boho5',
                                   :bohemian => 9,
                                   :classic => 3,
                                   :edgy => 6,
                                   :girly => 3,
                                   :glam => 3
                                 }, {
                                   :code => 'boho6',
                                   :bohemian => 9,
                                   :classic => 3,
                                   :edgy => 5,
                                   :girly => 4,
                                   :glam => 3
                                 }, {
                                   :code => 'boho7',
                                   :bohemian => 8,
                                   :classic => 3,
                                   :edgy => 6,
                                   :girly => 5,
                                   :glam => 6
                                 }, {
                                   :code => 'classic1',
                                   :bohemian => 3,
                                   :classic => 8,
                                   :edgy => 6,
                                   :girly => 3,
                                   :glam => 4
                                 }, {
                                   :code => 'classic2',
                                   :bohemian => 2,
                                   :classic => 9,
                                   :edgy => 3,
                                   :girly => 6,
                                   :glam => 6
                                 }, {
                                   :code => 'classic3',
                                   :bohemian => 2,
                                   :classic => 8,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 4
                                 }, {
                                   :code => 'classic4',
                                   :bohemian => 3,
                                   :classic => 7,
                                   :edgy => 6,
                                   :girly => 4,
                                   :glam => 5
                                 }, {
                                   :code => 'classic5',
                                   :bohemian => 4,
                                   :classic => 8,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'classic6',
                                   :bohemian => 5,
                                   :classic => 8,
                                   :edgy => 7,
                                   :girly => 6,
                                   :glam => 6
                                 }, {
                                   :code => 'classic7',
                                   :bohemian => 4,
                                   :classic => 9,
                                   :edgy => 3,
                                   :girly => 7,
                                   :glam => 7
                                 }, {
                                   :code => 'edgy1',
                                   :bohemian => 2,
                                   :classic => 2,
                                   :edgy => 9,
                                   :girly => 2,
                                   :glam => 2
                                 }, {
                                   :code => 'edgy2',
                                   :bohemian => 2,
                                   :classic => 2,
                                   :edgy => 9,
                                   :girly => 2,
                                   :glam => 2
                                 }, {
                                   :code => 'edgy3',
                                   :bohemian => 3,
                                   :classic => 3,
                                   :edgy => 9,
                                   :girly => 3,
                                   :glam => 3
                                 }, {
                                   :code => 'edgy4',
                                   :bohemian => 3,
                                   :classic => 2,
                                   :edgy => 9,
                                   :girly => 2,
                                   :glam => 2
                                 }, {
                                   :code => 'edgy5',
                                   :bohemian => 2,
                                   :classic => 2,
                                   :edgy => 9,
                                   :girly => 3,
                                   :glam => 4
                                 }, {
                                   :code => 'edgy6',
                                   :bohemian => 4,
                                   :classic => 3,
                                   :edgy => 9,
                                   :girly => 3,
                                   :glam => 4 
                                 }, {
                                   :code => 'edgy7',
                                   :bohemian => 3,
                                   :classic => 3,
                                   :edgy => 9,
                                   :girly => 5,
                                   :glam => 3
                                 }, {
                                   :code => 'girly1',
                                   :bohemian => 5,
                                   :classic => 7,
                                   :edgy => 3,
                                   :girly => 9,
                                   :glam => 7
                                 }, {
                                   :code => 'girly2',
                                   :bohemian => 3,
                                   :classic => 8,
                                   :edgy => 2,
                                   :girly => 9,
                                   :glam => 8
                                 }, {
                                   :code => 'girly3',
                                   :bohemian => 2,
                                   :classic => 6,
                                   :edgy => 6,
                                   :girly => 9,
                                   :glam => 7
                                 }, {
                                   :code => 'girly4',
                                   :bohemian => 2,
                                   :classic => 8,
                                   :edgy => 2,
                                   :girly => 9,
                                   :glam => 7
                                 }, {
                                   :code => 'girly5',
                                   :bohemian => 2,
                                   :classic => 8,
                                   :edgy => 2,
                                   :girly => 9,
                                   :glam => 7
                                 }, {
                                   :code => 'girly6',
                                   :bohemian => 3,
                                   :classic => 8,
                                   :edgy => 5,
                                   :girly => 9,
                                   :glam => 8
                                 }, {
                                   :code => 'girly7',
                                   :bohemian => 4,
                                   :classic => 7,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 7
                                 }, {
                                   :code => 'glam1',
                                   :bohemian => 2,
                                   :classic => 7,
                                   :edgy => 2,
                                   :girly => 6,
                                   :glam => 9
                                 }, {
                                   :code => 'glam2',
                                   :bohemian => 3,
                                   :classic => 7,
                                   :edgy => 6,
                                   :girly => 5,
                                   :glam => 9
                                 }, {
                                   :code => 'glam3',
                                   :bohemian => 3,
                                   :classic => 4,
                                   :edgy => 4,
                                   :girly => 4,
                                   :glam => 9
                                 }, {
                                   :code => 'glam4',
                                   :bohemian => 5,
                                   :classic => 6,
                                   :edgy => 6,
                                   :girly => 5,
                                   :glam => 9
                                 }, {
                                   :code => 'glam5',
                                   :bohemian => 4,
                                   :classic => 7,
                                   :edgy => 4,
                                   :girly => 7,
                                   :glam => 8
                                 }, {
                                   :code => 'glam6',
                                   :bohemian => 3,
                                   :classic => 7,
                                   :edgy => 6,
                                   :girly => 5,
                                   :glam => 9
                                 }, {
                                   :code => 'glam7',
                                   :bohemian => 3,
                                   :classic => 6,
                                   :edgy => 6,
                                   :girly => 5,
                                   :glam => 9
                                 }
                               ])

      # red carpet questions
      question = quiz.questions.find_by_partial!('oscar_dresses')
      question.answers.create!([
                                 {
                                   :code => 'boho1',
                                   :bohemian => 10,
                                   :classic => 0,
                                   :edgy => 3,
                                   :girly => 1,
                                   :glam => 1
                                 }, {
                                   :code => 'boho2',
                                   :bohemian => 7,
                                   :classic => 4,
                                   :edgy => 1,
                                   :girly => 1,
                                   :glam => 0
                                 }, {
                                   :code => 'boho3',
                                   :bohemian => 10,
                                   :classic => 0,
                                   :edgy => 2,
                                   :girly => 7,
                                   :glam => 1
                                 }, {
                                   :code => 'boho4',
                                   :bohemian => 10,
                                   :classic => 0,
                                   :edgy => 0,
                                   :girly => 2,
                                   :glam => 0
                                 }, {
                                   :code => 'boho5',
                                   :bohemian => 10,
                                   :classic => 3,
                                   :edgy => 0,
                                   :girly => 0,
                                   :glam => 0
                                 }, {
                                   :code => 'boho6',
                                   :bohemian => 10,
                                   :classic => 0,
                                   :edgy => 0,
                                   :girly => 2,
                                   :glam => 0
                                 }, {
                                   :code => 'boho7',
                                   :bohemian => 10,
                                   :classic => 0,
                                   :edgy => 0,
                                   :girly => 4,
                                   :glam => 0
                                 }, {
                                   :code => 'classic1',
                                   :bohemian => 0,
                                   :classic => 8,
                                   :edgy => 0,
                                   :girly => 5,
                                   :glam => 3
                                 }, {
                                   :code => 'classic2',
                                   :bohemian => 0,
                                   :classic => 10,
                                   :edgy => 3,
                                   :girly => 0,
                                   :glam => 5
                                 }, {
                                   :code => 'classic3',
                                   :bohemian => 0,
                                   :classic => 9,
                                   :edgy => 0,
                                   :girly => 3,
                                   :glam => 4
                                 }, {
                                   :code => 'classic4',
                                   :bohemian => 0,
                                   :classic => 10,
                                   :edgy => 0,
                                   :girly => 2,
                                   :glam => 4
                                 }, {
                                   :code => 'classic5',
                                   :bohemian => 0,
                                   :classic => 10,
                                   :edgy => 0,
                                   :girly => 1,
                                   :glam => 7
                                 }, {
                                   :code => 'classic6',
                                   :bohemian => 0,
                                   :classic => 10,
                                   :edgy => 0,
                                   :girly => 1,
                                   :glam => 6
                                 }, {
                                   :code => 'classic7',
                                   :bohemian => 0,
                                   :classic => 10,
                                   :edgy => 0,
                                   :girly => 4,
                                   :glam => 6
                                 }, {
                                   :code => 'edgy1',
                                   :bohemian => 0,
                                   :classic => 0,
                                   :edgy => 10,
                                   :girly => 0,
                                   :glam => 6
                                 }, {
                                   :code => 'edgy2',
                                   :bohemian => 2,
                                   :classic => 4,
                                   :edgy => 9,
                                   :girly => 0,
                                   :glam => 5
                                 }, {
                                   :code => 'edgy3',
                                   :bohemian => 1,
                                   :classic => 5,
                                   :edgy => 10,
                                   :girly => 0,
                                   :glam => 5
                                 }, {
                                   :code => 'edgy4',
                                   :bohemian => 5,
                                   :classic => 0,
                                   :edgy => 8,
                                   :girly => 0,
                                   :glam => 3
                                 }, {
                                   :code => 'edgy5',
                                   :bohemian => 4,
                                   :classic => 0,
                                   :edgy => 10,
                                   :girly => 2,
                                   :glam => 7
                                 }, {
                                   :code => 'edgy6',
                                   :bohemian => 0,
                                   :classic => 0,
                                   :edgy => 10,
                                   :girly => 0,
                                   :glam => 6
                                 }, {
                                   :code => 'edgy7',
                                   :bohemian => 0,
                                   :classic => 0,
                                   :edgy => 10,
                                   :girly => 0,
                                   :glam => 8
                                 }, {
                                   :code => 'girly1',
                                   :bohemian => 2,
                                   :classic => 6,
                                   :edgy => 0,
                                   :girly => 9,
                                   :glam => 4
                                 }, {
                                   :code => 'girly2',
                                   :bohemian => 0,
                                   :classic => 6,
                                   :edgy => 0,
                                   :girly => 10,
                                   :glam => 3
                                 }, {
                                   :code => 'girly3',
                                   :bohemian => 0,
                                   :classic => 9,
                                   :edgy => 0,
                                   :girly => 10,
                                   :glam => 1
                                 }, {
                                   :code => 'girly4',
                                   :bohemian => 3,
                                   :classic => 5,
                                   :edgy => 0,
                                   :girly => 10,
                                   :glam => 0
                                 }, {
                                   :code => 'girly5',
                                   :bohemian => 0,
                                   :classic => 7,
                                   :edgy => 0,
                                   :girly => 10,
                                   :glam => 1
                                 }, {
                                   :code => 'girly6',
                                   :bohemian => 0,
                                   :classic => 4,
                                   :edgy => 1,
                                   :girly => 9,
                                   :glam => 7 
                                 }, {
                                   :code => 'girly7',
                                   :bohemian => 2,
                                   :classic => 6,
                                   :edgy => 4,
                                   :girly => 7,
                                   :glam => 9
                                 }, {
                                   :code => 'glam1',
                                   :bohemian => 0,
                                   :classic => 5,
                                   :edgy => 5,
                                   :girly => 0,
                                   :glam => 10
                                 }, {
                                   :code => 'glam2',
                                   :bohemian => 2,
                                   :classic => 3,
                                   :edgy => 4,
                                   :girly => 0,
                                   :glam => 9
                                 }, {
                                   :code => 'glam3',
                                   :bohemian => 0,
                                   :classic => 3,
                                   :edgy => 7,
                                   :girly => 0,
                                   :glam => 9
                                 }, {
                                   :code => 'glam4',
                                   :bohemian => 0,
                                   :classic => 3,
                                   :edgy => 5,
                                   :girly => 0,
                                   :glam => 10
                                 }, {
                                   :code => 'glam5',
                                   :bohemian => 1,
                                   :classic => 3,
                                   :edgy => 5,
                                   :girly => 0,
                                   :glam => 10
                                 }, {
                                   :code => 'glam6',
                                   :bohemian => 4,
                                   :classic => 0,
                                   :edgy => 4,
                                   :girly => 0,
                                   :glam => 9
                                 }, {
                                   :code => 'glam7',
                                   :bohemian => 0,
                                   :classic => 3,
                                   :edgy => 2,
                                   :girly => 0,
                                   :glam => 9
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
                                   :code => 'dramatic1',
                                   :bohemian => 2,
                                   :classic => 5,
                                   :edgy => 8,
                                   :girly => 3,
                                   :glam => 7
                                 }, {
                                   :code => 'dramatic2',
                                   :bohemian => 3,
                                   :classic => 7,
                                   :edgy => 7,
                                   :girly => 6,
                                   :glam => 7
                                 }, {
                                   :code => 'dramatic3',
                                   :bohemian => 2,
                                   :classic => 4,
                                   :edgy => 5,
                                   :girly => 7,
                                   :glam => 6
                                 }, {
                                   :code => 'dramatic4',
                                   :bohemian => 4,
                                   :classic => 6,
                                   :edgy => 6,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'dramatic5',
                                   :bohemian => 4,
                                   :classic => 2,
                                   :edgy => 8,
                                   :girly => 4,
                                   :glam => 4
                                 }, {
                                   :code => 'dramatic6',
                                   :bohemian => 3,
                                   :classic => 8,
                                   :edgy => 6,
                                   :girly => 7,
                                   :glam => 8 
                                 }, {
                                   :code => 'dramatic7',
                                   :bohemian => 4,
                                   :classic => 8,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'romantic1',
                                   :bohemian => 5,
                                   :classic => 8,
                                   :edgy => 5,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'romantic2',
                                   :bohemian => 5,
                                   :classic => 8,
                                   :edgy => 3,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'romantic3',
                                   :bohemian => 6,
                                   :classic => 5,
                                   :edgy => 6,
                                   :girly => 8,
                                   :glam =>5 
                                 }, {
                                   :code => 'romantic4',
                                   :bohemian => 5,
                                   :classic => 7,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 7
                                 }, {
                                   :code => 'romantic5',
                                   :bohemian => 5,
                                   :classic => 7,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 7
                                 }, {
                                   :code => 'romantic6',
                                   :bohemian => 4,
                                   :classic => 8,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'romantic7',
                                   :bohemian => 3,
                                   :classic => 6,
                                   :edgy => 3,
                                   :girly => 9,
                                   :glam => 7
                                 }, {
                                   :code => 'edgy1',
                                   :bohemian => 2,
                                   :classic => 4,
                                   :edgy => 9,
                                   :girly => 2,
                                   :glam => 3
                                 }, {
                                   :code => 'edgy2',
                                   :bohemian => 3,
                                   :classic => 1,
                                   :edgy => 9,
                                   :girly => 2,
                                   :glam => 4
                                 }, {
                                   :code => 'edgy3',
                                   :bohemian => 3,
                                   :classic => 5,
                                   :edgy => 8,
                                   :girly => 5,
                                   :glam => 5
                                 }, {
                                   :code => 'edgy4',
                                   :bohemian => 3,
                                   :classic => 3,
                                   :edgy => 9,
                                   :girly => 5,
                                   :glam => 5
                                 }, {
                                   :code => 'edgy5',
                                   :bohemian => 3,
                                   :classic => 2,
                                   :edgy => 9,
                                   :girly => 2,
                                   :glam => 2
                                 }, {
                                   :code => 'edgy6',
                                   :bohemian => 1,
                                   :classic => 1,
                                   :edgy => 9,
                                   :girly => 2,
                                   :glam => 2
                                 }, {
                                   :code => 'edgy7',
                                   :bohemian => 4,
                                   :classic => 5,
                                   :edgy => 8,
                                   :girly => 5,
                                   :glam => 5
                                 }, {
                                   :code => 'statement1',
                                   :bohemian => 3,
                                   :classic => 2,
                                   :edgy => 6,
                                   :girly => 6,
                                   :glam => 5
                                 }, {
                                   :code => 'statement2',
                                   :bohemian => 3,
                                   :classic => 2,
                                   :edgy => 5,
                                   :girly => 5,
                                   :glam => 6
                                 }, {
                                   :code => 'statement3',
                                   :bohemian => 4,
                                   :classic => 5,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'statement4',
                                   :bohemian => 4,
                                   :classic => 4,
                                   :edgy => 6,
                                   :girly => 7,
                                   :glam => 6
                                 }, {
                                   :code => 'statement5',
                                   :bohemian => 3,
                                   :classic => 3,
                                   :edgy => 5,
                                   :girly => 6,
                                   :glam => 7
                                 }, {
                                   :code => 'statement6',
                                   :bohemian => 3,
                                   :classic => 3,
                                   :edgy => 7,
                                   :girly => 6,
                                   :glam => 6
                                 }, {
                                   :code => 'statement7',
                                   :bohemian => 3,
                                   :classic => 4,
                                   :edgy => 7,
                                   :girly => 7,
                                   :glam => 7
                                 }, {
                                   :code => 'natural1',
                                   :bohemian => 9,
                                   :classic => 7,
                                   :edgy => 4,
                                   :girly => 7,
                                   :glam => 4
                                 }, {
                                   :code => 'natural2',
                                   :bohemian => 9,
                                   :classic => 8,
                                   :edgy => 4,
                                   :girly => 6,
                                   :glam => 5
                                 }, {
                                   :code => 'natural3',
                                   :bohemian => 9,
                                   :classic => 7,
                                   :edgy => 4,
                                   :girly => 7,
                                   :glam => 4
                                 }, {
                                   :code => 'natural4',
                                   :bohemian => 9,
                                   :classic => 8,
                                   :edgy => 2,
                                   :girly => 8,
                                   :glam => 5 
                                 }, {
                                   :code => 'natural5',
                                   :bohemian => 9,
                                   :classic => 8,
                                   :edgy => 4,
                                   :girly => 6,
                                   :glam => 5
                                 }, {
                                   :code => 'natural6',
                                   :bohemian => 9,
                                   :classic => 7,
                                   :edgy => 4,
                                   :girly => 7,
                                   :glam => 4
                                 }, {
                                   :code => 'natural7',
                                   :bohemian => 9,
                                   :classic => 7,
                                   :edgy => 4,
                                   :girly => 7,
                                   :glam => 4
                                 }
                               ])

      question = quiz.questions.find_by_partial!('prom_hair')
      question.answers.create!([
                                 {
                                   :code => 'boho1',
                                   :bohemian => 9,
                                   :classic => 3,
                                   :edgy => 4,
                                   :girly => 6,
                                   :glam => 5
                                 }, {
                                   :code => 'boho2',
                                   :bohemian => 9,
                                   :classic => 5,
                                   :edgy => 5,
                                   :girly => 6,
                                   :glam => 4
                                 }, {
                                   :code => 'boho3',
                                   :bohemian => 9,
                                   :classic => 5,
                                   :edgy => 5,
                                   :girly => 6,
                                   :glam => 4 
                                 }, {
                                   :code => 'boho4',
                                   :bohemian => 9,
                                   :classic => 3,
                                   :edgy => 6,
                                   :girly => 5,
                                   :glam => 5
                                 }, {
                                   :code => 'boho5',
                                   :bohemian => 9,
                                   :classic => 4,
                                   :edgy => 6,
                                   :girly => 6,
                                   :glam => 5
                                 }, {
                                   :code => 'boho6',
                                   :bohemian => 9,
                                   :classic => 3,
                                   :edgy => 5,
                                   :girly => 6,
                                   :glam => 4
                                 }, {
                                   :code => 'boho7',
                                   :bohemian => 9,
                                   :classic => 7,
                                   :edgy => 7,
                                   :girly => 7,
                                   :glam => 7
                                 }, {
                                   :code => 'classic1',
                                   :bohemian => 3,
                                   :classic => 9,
                                   :edgy => 3,
                                   :girly => 7,
                                   :glam => 8
                                 }, {
                                   :code => 'classic2',
                                   :bohemian => 2,
                                   :classic => 9,
                                   :edgy => 4,
                                   :girly => 7,
                                   :glam => 7
                                 }, {
                                   :code => 'classic3',
                                   :bohemian => 5,
                                   :classic => 9,
                                   :edgy => 5,
                                   :girly => 8,
                                   :glam => 4
                                 }, {
                                   :code => 'classic4',
                                   :bohemian => 2,
                                   :classic => 9,
                                   :edgy => 2,
                                   :girly => 7,
                                   :glam => 8
                                 }, {
                                   :code => 'classic5',
                                   :bohemian => 2,
                                   :classic => 9,
                                   :edgy => 2,
                                   :girly => 7,
                                   :glam => 8
                                 }, {
                                   :code => 'classic6',
                                   :bohemian => 2,
                                   :classic => 9,
                                   :edgy => 3,
                                   :girly => 7,
                                   :glam => 8
                                 }, {
                                   :code => 'classic7',
                                   :bohemian => 4,
                                   :classic => 9,
                                   :edgy => 1,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'edgy1',
                                   :bohemian => 3,
                                   :classic => 2,
                                   :edgy => 9,
                                   :girly => 4,
                                   :glam => 4
                                 }, {
                                   :code => 'edgy2',
                                   :bohemian => 2,
                                   :classic => 7,
                                   :edgy => 6,
                                   :girly => 7,
                                   :glam => 8
                                 }, {
                                   :code => 'edgy3',
                                   :bohemian => 5,
                                   :classic => 7,
                                   :edgy => 7,
                                   :girly => 7,
                                   :glam => 7
                                 }, {
                                   :code => 'edgy4',
                                   :bohemian => 6,
                                   :classic => 4,
                                   :edgy => 8,
                                   :girly => 7,
                                   :glam => 7
                                 }, {
                                   :code => 'edgy5',
                                   :bohemian => 6,
                                   :classic => 3,
                                   :edgy => 8,
                                   :girly => 6,
                                   :glam => 4
                                 }, {
                                   :code => 'edgy6',
                                   :bohemian => 6,
                                   :classic => 5,
                                   :edgy => 8,
                                   :girly => 7,
                                   :glam => 5
                                 }, {
                                   :code => 'edgy7',
                                   :bohemian => 4,
                                   :classic => 2,
                                   :edgy => 8,
                                   :girly => 5,
                                   :glam => 5
                                 }, {
                                   :code => 'girly1',
                                   :bohemian => 5,
                                   :classic => 7,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'girly2',
                                   :bohemian => 5,
                                   :classic => 4,
                                   :edgy => 6,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'girly3',
                                   :bohemian => 3,
                                   :classic => 5,
                                   :edgy => 5,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'girly4',
                                   :bohemian => 6,
                                   :classic => 6,
                                   :edgy => 6,
                                   :girly => 8,
                                   :glam => 6
                                 }, {
                                   :code => 'girly5',
                                   :bohemian => 5,
                                   :classic => 5,
                                   :edgy => 5,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'girly6',
                                   :bohemian => 4,
                                   :classic => 5,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'girly7',
                                   :bohemian => 4,
                                   :classic => 7,
                                   :edgy => 5,
                                   :girly => 8,
                                   :glam => 7
                                 }, {
                                   :code => 'glam1',
                                   :bohemian => 2,
                                   :classic => 8,
                                   :edgy => 2,
                                   :girly => 7,
                                   :glam => 9
                                 }, {
                                   :code => 'glam2',
                                   :bohemian => 3,
                                   :classic => 8,
                                   :edgy => 2,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'glam3',
                                   :bohemian => 3,
                                   :classic => 8,
                                   :edgy => 3,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'glam4',
                                   :bohemian => 3,
                                   :classic => 8,
                                   :edgy => 6,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'glam5',
                                   :bohemian => 3,
                                   :classic => 6,
                                   :edgy => 6,
                                   :girly => 6,
                                   :glam => 8
                                 }, {
                                   :code => 'glam6',
                                   :bohemian => 2,
                                   :classic => 8,
                                   :edgy => 2,
                                   :girly => 8,
                                   :glam => 9
                                 }, {
                                   :code => 'glam7',
                                   :bohemian => 3,
                                   :classic => 8,
                                   :edgy => 5,
                                   :girly => 8,
                                   :glam => 9
                                 }
                               ])

      # runway question
      question = quiz.questions.find_by_partial!('prom_dresses')
      question.answers.create!([
                                 {
                                   :code => 'boho1',
                                   :bohemian => 8,
                                   :classic => 5,
                                   :edgy => 6,
                                   :girly => 5,
                                   :glam => 5
                                 }, {
                                   :code => 'boho2',
                                   :bohemian => 8,
                                   :classic => 2,
                                   :edgy => 8,
                                   :girly => 5,
                                   :glam => 5
                                 }, {
                                   :code => 'boho3',
                                   :bohemian => 9,
                                   :classic => 3,
                                   :edgy => 3,
                                   :girly => 5,
                                   :glam => 3
                                 }, {
                                   :code => 'boho4',
                                   :bohemian => 9,
                                   :classic => 7,
                                   :edgy => 3,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'boho5',
                                   :bohemian => 9,
                                   :classic => 3,
                                   :edgy => 4,
                                   :girly => 5,
                                   :glam => 3
                                 }, {
                                   :code => 'boho6',
                                   :bohemian => 9,
                                   :classic => 3,
                                   :edgy => 5,
                                   :girly => 5,
                                   :glam => 3
                                 }, {
                                   :code => 'boho7',
                                   :bohemian => 9,
                                   :classic => 3,
                                   :edgy => 5,
                                   :girly => 5,
                                   :glam => 5
                                 }, {
                                   :code => 'classic1',
                                   :bohemian => 5,
                                   :classic => 9,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'classic2',
                                   :bohemian => 3,
                                   :classic => 9,
                                   :edgy => 3,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'classic3',
                                   :bohemian => 2,
                                   :classic => 9,
                                   :edgy => 3,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'classic4',
                                   :bohemian => 4,
                                   :classic => 8,
                                   :edgy => 4,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'classic5',
                                   :bohemian => 5,
                                   :classic => 8,
                                   :edgy => 3,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'classic6',
                                   :bohemian => 2,
                                   :classic => 9,
                                   :edgy => 3,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'classic7',
                                   :bohemian => 4,
                                   :classic => 9,
                                   :edgy => 3,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'edgy1',
                                   :bohemian => 4,
                                   :classic => 3,
                                   :edgy => 8,
                                   :girly => 6,
                                   :glam => 6
                                 }, {
                                   :code => 'edgy2',
                                   :bohemian => 4,
                                   :classic => 5,
                                   :edgy => 9,
                                   :girly => 6,
                                   :glam => 6
                                 }, {
                                   :code => 'edgy3',
                                   :bohemian => 2,
                                   :classic => 5,
                                   :edgy => 8,
                                   :girly => 5,
                                   :glam => 6
                                 }, {
                                   :code => 'edgy4',
                                   :bohemian => 4,
                                   :classic => 5,
                                   :edgy => 8,
                                   :girly => 5,
                                   :glam => 6
                                 }, {
                                   :code => 'edgy5',
                                   :bohemian => 6,
                                   :classic => 5,
                                   :edgy => 8,
                                   :girly => 7,
                                   :glam => 6
                                 }, {
                                   :code => 'edgy6',
                                   :bohemian => 6,
                                   :classic => 3,
                                   :edgy => 8,
                                   :girly => 6,
                                   :glam => 6
                                 }, {
                                   :code => 'edgy7',
                                   :bohemian => 6,
                                   :classic => 3,
                                   :edgy => 8,
                                   :girly => 6,
                                   :glam => 6
                                 }, {
                                   :code => 'girly1',
                                   :bohemian => 5,
                                   :classic => 3,
                                   :edgy => 6,
                                   :girly => 9,
                                   :glam => 8
                                 }, {
                                   :code => 'girly2',
                                   :bohemian => 5,
                                   :classic => 4,
                                   :edgy => 7,
                                   :girly => 8,
                                   :glam => 7
                                 }, {
                                   :code => 'girly3',
                                   :bohemian => 2,
                                   :classic => 7,
                                   :edgy => 3,
                                   :girly => 8,
                                   :glam => 8
                                 }, {
                                   :code => 'girly4',
                                   :bohemian => 6,
                                   :classic => 6,
                                   :edgy => 6,
                                   :girly => 9,
                                   :glam => 7
                                 }, {
                                   :code => 'girly5',
                                   :bohemian => 6,
                                   :classic => 7,
                                   :edgy => 8,
                                   :girly => 7,
                                   :glam => 6
                                 }, {
                                   :code => 'girly6',
                                   :bohemian => 8,
                                   :classic => 8,
                                   :edgy => 5,
                                   :girly => 8,
                                   :glam => 6
                                 }, {
                                   :code => 'girly7',
                                   :bohemian => 5,
                                   :classic => 8,
                                   :edgy => 6,
                                   :girly => 9,
                                   :glam => 8
                                 }, {
                                   :code => 'glam1',
                                   :bohemian => 4,
                                   :classic => 5,
                                   :edgy => 5,
                                   :girly => 5,
                                   :glam => 8
                                 }, {
                                   :code => 'glam2',
                                   :bohemian => 5,
                                   :classic => 7,
                                   :edgy => 5,
                                   :girly => 8,
                                   :glam => 9
                                 }, {
                                   :code => 'glam3',
                                   :bohemian => 2,
                                   :classic => 4,
                                   :edgy => 4,
                                   :girly => 5,
                                   :glam => 9
                                 }, {
                                   :code => 'glam4',
                                   :bohemian => 3,
                                   :classic => 6,
                                   :edgy => 3,
                                   :girly => 7,
                                   :glam => 8
                                 }, {
                                   :code => 'glam5',
                                   :bohemian => 2,
                                   :classic => 2,
                                   :edgy => 6,
                                   :girly => 5,
                                   :glam => 9
                                 }, {
                                   :code => 'glam6',
                                   :bohemian => 4,
                                   :classic => 7,
                                   :edgy => 3,
                                   :girly => 6,
                                   :glam => 8
                                 }, {
                                   :code => 'glam7',
                                   :bohemian => 2,
                                   :classic => 8,
                                   :edgy => 2,
                                   :girly => 7,
                                   :glam => 9
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
                                   :code => 'red'
                                 }, {
                                   :code => 'blonde'
                                 }, {
                                   :code => 'platinum_blonde'
                                 }, {
                                   :code => 'strawberry_blonde'
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
