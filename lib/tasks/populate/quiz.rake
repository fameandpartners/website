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
                                 :text => 'Which of these runway looks would inspire your dream formal dress?',
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
                                   :code => 'image_1',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_4',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_10',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_13',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_21',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_27',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_34',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_3',
                                   :classic => 10
                                 }, {
                                   :code => 'image_7',
                                   :classic => 10
                                 }, {
                                   :code => 'image_14',
                                   :classic => 10
                                 }, {
                                   :code => 'image_19',
                                   :classic => 10
                                 }, {
                                   :code => 'image_23',
                                   :classic => 10
                                 }, {
                                   :code => 'image_28',
                                   :classic => 10
                                 }, {
                                   :code => 'image_33',
                                   :classic => 10
                                 }, {
                                   :code => 'image_2',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_6',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_17',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_20',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_25',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_30',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_35',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_5',
                                   :girly => 10
                                 }, {
                                   :code => 'image_9',
                                   :girly => 10
                                 }, {
                                   :code => 'image_12',
                                   :girly => 10
                                 }, {
                                   :code => 'image_16',
                                   :girly => 10
                                 }, {
                                   :code => 'image_18',
                                   :girly => 10
                                 }, {
                                   :code => 'image_26',
                                   :girly => 10
                                 }, {
                                   :code => 'image_31',
                                   :girly => 10
                                 }, {
                                   :code => 'image_8',
                                   :glam => 10
                                 }, {
                                   :code => 'image_11',
                                   :glam => 10
                                 }, {
                                   :code => 'image_15',
                                   :glam => 10
                                 }, {
                                   :code => 'image_22',
                                   :glam => 10
                                 }, {
                                   :code => 'image_24',
                                   :glam => 10
                                 }, {
                                   :code => 'image_29',
                                   :glam => 10
                                 }, {
                                   :code => 'image_32',
                                   :glam => 10
                                 }
                               ])

      question = quiz.questions.find_by_partial!('oscar_dresses')
      question.answers.create!([
                                 {
                                   :code => 'image_1',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_4',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_10',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_13',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_21',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_27',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_34',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_3',
                                   :classic => 10
                                 }, {
                                   :code => 'image_7',
                                   :classic => 10
                                 }, {
                                   :code => 'image_14',
                                   :classic => 10
                                 }, {
                                   :code => 'image_19',
                                   :classic => 10
                                 }, {
                                   :code => 'image_23',
                                   :classic => 10
                                 }, {
                                   :code => 'image_28',
                                   :classic => 10
                                 }, {
                                   :code => 'image_33',
                                   :classic => 10
                                 }, {
                                   :code => 'image_2',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_6',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_17',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_20',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_25',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_30',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_35',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_5',
                                   :girly => 10
                                 }, {
                                   :code => 'image_9',
                                   :girly => 10
                                 }, {
                                   :code => 'image_12',
                                   :girly => 10
                                 }, {
                                   :code => 'image_16',
                                   :girly => 10
                                 }, {
                                   :code => 'image_18',
                                   :girly => 10
                                 }, {
                                   :code => 'image_26',
                                   :girly => 10
                                 }, {
                                   :code => 'image_31',
                                   :girly => 10
                                 }, {
                                   :code => 'image_8',
                                   :glam => 10
                                 }, {
                                   :code => 'image_11',
                                   :glam => 10
                                 }, {
                                   :code => 'image_15',
                                   :glam => 10
                                 }, {
                                   :code => 'image_22',
                                   :glam => 10
                                 }, {
                                   :code => 'image_24',
                                   :glam => 10
                                 }, {
                                   :code => 'image_29',
                                   :glam => 10
                                 }, {
                                   :code => 'image_32',
                                   :glam => 10
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
                                   :code => 'image_1',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_4',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_10',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_13',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_21',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_27',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_34',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_3',
                                   :classic => 10
                                 }, {
                                   :code => 'image_7',
                                   :classic => 10
                                 }, {
                                   :code => 'image_14',
                                   :classic => 10
                                 }, {
                                   :code => 'image_19',
                                   :classic => 10
                                 }, {
                                   :code => 'image_23',
                                   :classic => 10
                                 }, {
                                   :code => 'image_28',
                                   :classic => 10
                                 }, {
                                   :code => 'image_33',
                                   :classic => 10
                                 }, {
                                   :code => 'image_2',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_6',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_17',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_20',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_25',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_30',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_35',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_5',
                                   :girly => 10
                                 }, {
                                   :code => 'image_9',
                                   :girly => 10
                                 }, {
                                   :code => 'image_12',
                                   :girly => 10
                                 }, {
                                   :code => 'image_16',
                                   :girly => 10
                                 }, {
                                   :code => 'image_18',
                                   :girly => 10
                                 }, {
                                   :code => 'image_26',
                                   :girly => 10
                                 }, {
                                   :code => 'image_31',
                                   :girly => 10
                                 }, {
                                   :code => 'image_8',
                                   :glam => 10
                                 }, {
                                   :code => 'image_11',
                                   :glam => 10
                                 }, {
                                   :code => 'image_15',
                                   :glam => 10
                                 }, {
                                   :code => 'image_22',
                                   :glam => 10
                                 }, {
                                   :code => 'image_24',
                                   :glam => 10
                                 }, {
                                   :code => 'image_29',
                                   :glam => 10
                                 }, {
                                   :code => 'image_32',
                                   :glam => 10
                                 }
                               ])

      question = quiz.questions.find_by_partial!('prom_hair')
      question.answers.create!([
                                 {
                                   :code => 'image_1',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_4',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_10',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_13',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_21',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_27',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_34',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_3',
                                   :classic => 10
                                 }, {
                                   :code => 'image_7',
                                   :classic => 10
                                 }, {
                                   :code => 'image_14',
                                   :classic => 10
                                 }, {
                                   :code => 'image_19',
                                   :classic => 10
                                 }, {
                                   :code => 'image_23',
                                   :classic => 10
                                 }, {
                                   :code => 'image_28',
                                   :classic => 10
                                 }, {
                                   :code => 'image_33',
                                   :classic => 10
                                 }, {
                                   :code => 'image_2',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_6',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_17',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_20',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_25',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_30',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_35',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_5',
                                   :girly => 10
                                 }, {
                                   :code => 'image_9',
                                   :girly => 10
                                 }, {
                                   :code => 'image_12',
                                   :girly => 10
                                 }, {
                                   :code => 'image_16',
                                   :girly => 10
                                 }, {
                                   :code => 'image_18',
                                   :girly => 10
                                 }, {
                                   :code => 'image_26',
                                   :girly => 10
                                 }, {
                                   :code => 'image_31',
                                   :girly => 10
                                 }, {
                                   :code => 'image_8',
                                   :glam => 10
                                 }, {
                                   :code => 'image_11',
                                   :glam => 10
                                 }, {
                                   :code => 'image_15',
                                   :glam => 10
                                 }, {
                                   :code => 'image_22',
                                   :glam => 10
                                 }, {
                                   :code => 'image_24',
                                   :glam => 10
                                 }, {
                                   :code => 'image_29',
                                   :glam => 10
                                 }, {
                                   :code => 'image_32',
                                   :glam => 10
                                 }
                               ])

      question = quiz.questions.find_by_partial!('prom_dresses')
      question.answers.create!([
                                 {
                                   :code => 'image_1',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_4',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_10',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_13',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_21',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_27',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_34',
                                   :bohemian => 10
                                 }, {
                                   :code => 'image_3',
                                   :classic => 10
                                 }, {
                                   :code => 'image_7',
                                   :classic => 10
                                 }, {
                                   :code => 'image_14',
                                   :classic => 10
                                 }, {
                                   :code => 'image_19',
                                   :classic => 10
                                 }, {
                                   :code => 'image_23',
                                   :classic => 10
                                 }, {
                                   :code => 'image_28',
                                   :classic => 10
                                 }, {
                                   :code => 'image_33',
                                   :classic => 10
                                 }, {
                                   :code => 'image_2',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_6',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_17',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_20',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_25',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_30',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_35',
                                   :edgy => 10
                                 }, {
                                   :code => 'image_5',
                                   :girly => 10
                                 }, {
                                   :code => 'image_9',
                                   :girly => 10
                                 }, {
                                   :code => 'image_12',
                                   :girly => 10
                                 }, {
                                   :code => 'image_16',
                                   :girly => 10
                                 }, {
                                   :code => 'image_18',
                                   :girly => 10
                                 }, {
                                   :code => 'image_26',
                                   :girly => 10
                                 }, {
                                   :code => 'image_31',
                                   :girly => 10
                                 }, {
                                   :code => 'image_8',
                                   :glam => 10
                                 }, {
                                   :code => 'image_11',
                                   :glam => 10
                                 }, {
                                   :code => 'image_15',
                                   :glam => 10
                                 }, {
                                   :code => 'image_22',
                                   :glam => 10
                                 }, {
                                   :code => 'image_24',
                                   :glam => 10
                                 }, {
                                   :code => 'image_29',
                                   :glam => 10
                                 }, {
                                   :code => 'image_32',
                                   :glam => 10
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
