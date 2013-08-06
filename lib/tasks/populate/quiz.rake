namespace :db do
  namespace :populate do
    desc 'Create default quiz'
    task :quiz => :environment do
      quiz = Quiz.create!(:name => 'Style Quiz')

      quiz.questions.create!([
                               {
                                 :text => "Choose the look that's closest to your everyday style?",
                                 :position => 1001,
                                 :partial => 'outfits'
                               }, {
                                 :text => "You're walking the red carpet. Which dress would you wear?",
                                 :position => 1002,
                                 :partial => 'oscar_dresses'
                               }, {
                                 :text => "It's time to dress up. Which best describes your style.",
                                 :position => 1003,
                                 :multiple => true,
                                 :partial => 'style_words'
                               }, {
                                 :text => "Which brands speak to your style?",
                                 :position => 1004,
                                 :multiple => true,
                                 :partial => 'brands',
                                 :populate => 'brands'
                               }, {
                                 :text => "You've won a shoe shopping spree. Which ones do you nab?",
                                 :position => 1005,
                                 :partial => 'prom_shoes'
                               }, {
                                 :text => 'Tell us which eye makeup look you love.',
                                 :position => 1006,
                                 :partial => 'prom_makeup'
                               }, {
                                 :text => 'Whether it works for you or not, which hair style do you love?',
                                 :position => 1007,
                                 :partial => 'prom_hair'
                               }, {
                                 :text => 'Which of these runway looks would inspire your dream formal dress?',
                                 :position => 1008,
                                 :partial => 'prom_dresses'
                               #}, {
                               #  :text => 'Which of these nail colours do you regularly wear?',
                               #  :position => 1009,
                               #  :multiple => true,
                               #  :partial => 'nail_colours',
                               #  :populate => 'nail_colours'
                               }, {
                                 :text => 'What are your favorite colors?',
                                 :position => 1010,
                                 :multiple => true,
                                 :partial => 'colours',
                                 :populate => 'colours'
                               }, {
                                 :text => 'How important is fashion to you?',
                                 :position => 1011,
                                 :partial => 'fashionability'
                               }, {
                                 :text => 'Do you prefer to show some skin or to cover up? Rank how sexy you like to look.',
                                 :position => 1012,
                                 :partial => 'sexiness'
                               #}, {
                               #  :text => 'Do you loathe or love any of these current fashion trends?',
                               #  :position => 1013,
                               #  :partial => 'trends',
                               #  :populate => 'trends'
                               }, {
                                 :text => 'What is your hair colour?',
                                 :position => 1014,
                                 :partial => 'hair_colours',
                                 :populate => 'hair_colour'
                               }, {
                                 :text => 'What is your skin colour?',
                                 :position => 1015,
                                 :partial => 'skin_colours',
                                 :populate => 'skin_colour'
                               }, {
                                 :text => 'What is your body shape?',
                                 :position => 1016,
                                 :partial => 'body_shapes',
                                 :populate => 'body_shape'
                               }, {
                                 :text => 'What is your typical size?',
                                 :position => 1017,
                                 :partial => 'typical_sizes',
                                 :populate => 'typical_size'
                               }, {
                                 :text => 'What is your bra size?',
                                 :position => 1018,
                                 :partial => 'bra_sizes',
                                 :populate => 'bra_size'
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


      question = quiz.questions.find_by_partial!('brands')
      question.answers.create!([
                                 {
                                   :code => 'chanel',
                                   :glam => 5,
                                   :classic => 5
                                 }, {
                                   :code => 'burberry',
                                   :edgy => 3,
                                   :bohemian => 2,
                                   :classic => 5
                                 }, {
                                   :code => 'lavin',
                                   :glam => 5,
                                   :edgy => 2,
                                   :bohemian => 3
                                 }, {
                                   :code => 'christian_dior',
                                   :glam => 10
                                 }, {
                                   :code => 'jil_sander',
                                   :edgy => 10
                                 }, {
                                   :code => 'zuhair_murad',
                                   :glam => 5,
                                   :bohemian => 5
                                 }, {
                                   :code => 'gucci',
                                   :glam => 5,
                                   :edgy => 5
                                 }, {
                                   :code => 'sass_bide',
                                   :edgy => 5,
                                   :bohemian => 5
                                 }, {
                                   :code => 'miu_miu',
                                   :glam => 2,
                                   :girly => 6,
                                   :classic => 2
                                 }, {
                                   :code => 'chloe',
                                   :girly => 2,
                                   :edgy => 6,
                                   :classic => 2
                                 }, {
                                   :code => 'kate_spade',
                                   :girly => 5,
                                   :classic => 5
                                 }, {
                                   :code => 'ralph_lauren',
                                   :girly => 3,
                                   :classic => 7
                                 }
                               ])


      question = quiz.questions.find_by_partial!('prom_shoes')
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


      question = quiz.questions.find_by_partial!('prom_makeup')
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


      #question = quiz.questions.find_by_partial!('nail_colours')
      #question.answers.create!([
      #                           {
      #                             :code => 'neon_yellow',
      #                             :glam => 3,
      #                             :edgy => 5,
      #                             :bohemian => 2
      #                           }, {
      #                             :code => 'neutral',
      #                             :girly => 4,
      #                             :classic => 6
      #                           }, {
      #                             :code => 'mint',
      #                             :girly => 3,
      #                             :edgy => 3,
      #                             :bohemian => 3
      #                           }, {
      #                             :code => 'navy',
      #                             :glam => 4,
      #                             :edgy => 2,
      #                             :bohemian => 2,
      #                             :classic => 2
      #                           }, {
      #                             :code => 'black',
      #                             :glam => 3,
      #                             :edgy => 3,
      #                             :bohemian => 4
      #                           }, {
      #                             :code => 'glittery',
      #                             :glam => 2,
      #                             :girly => 4,
      #                             :edgy => 4
      #                           }, {
      #                             :code => 'lilac',
      #                             :girly => 8,
      #                             :classic => 2
      #                           }, {
      #                             :code => 'light_pink',
      #                             :girly => 6,
      #                             :classic => 4
      #                           }, {
      #                             :code => 'french_tip',
      #                             :girly => 4,
      #                             :classic => 6
      #                           }, {
      #                             :code => 'gold',
      #                             :glam => 4,
      #                             :edgy => 4,
      #                             :classic => 2
      #                           }, {
      #                             :code => 'purple',
      #                             :edgy => 2,
      #                             :bohemian => 5
      #                           }, {
      #                             :code => 'bright_red',
      #                             :glam => 7,
      #                             :edgy => 3
      #                           }
      #                         ])

      question = quiz.questions.find_by_partial!('colours')
      question.answers.create!([
                                 {
                                   :code => 'black'
                                 }, {
                                   :code => 'navy'
                                 }, {
                                   :code => 'cobalt'
                                 }, {
                                   :code => 'blue'
                                 }, {
                                   :code => 'brown'
                                 }, {
                                   :code => 'purple'
                                 }, {
                                   :code => 'fuchsia'
                                 }, {
                                   :code => 'fluro'
                                 }, {
                                   :code => 'maroon'
                                 }, {
                                   :code => 'red'
                                 }, {
                                   :code => 'pink'
                                 }, {
                                   :code => 'mauve'
                                 }, {
                                   :code => 'ivory'
                                 }, {
                                   :code => 'camel'
                                 }, {
                                   :code => 'beige'
                                 }, {
                                   :code => 'orange'
                                 }, {
                                   :code => 'burnt_orange'
                                 }, {
                                   :code => 'canary'
                                 }, {
                                   :code => 'green'
                                 }, {
                                   :code => 'white'
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


      #question = quiz.questions.find_by_partial!('trends')
      #question.answers.create!([
      #                           {
      #                             :code => 'jewel_tones'
      #                           }, {
      #                             :code => 'volumnious_skirts'
      #                           }, {
      #                             :code => 'sequins'
      #                           }, {
      #                             :code => 'neon'
      #                           }, {
      #                             :code => 'lace_and_mesh'
      #                           }, {
      #                             :code => 'applique'
      #                           }, {
      #                             :code => 'digital_prints'
      #                           }
      #                         ])

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

      question = quiz.questions.find_by_partial!('typical_sizes')
      question.answers.create!([
                                 {
                                   :code => 'G4'
                                 }, {
                                   :code => 'G6'
                                 }, {
                                   :code => 'G8'
                                 }, {
                                   :code => 'G10'
                                 }, {
                                   :code => 'G12'
                                 }, {
                                   :code => 'G14'
                                 }, {
                                   :code => 'G16'
                                 }
                               ])

      question = quiz.questions.find_by_partial!('bra_sizes')
      question.answers.create!([
                                 {
                                   :code => 'AAA'
                                 }, {
                                   :code => 'AA'
                                 }, {
                                   :code => 'A'
                                 }, {
                                   :code => 'B'
                                 }, {
                                   :code => 'C'
                                 }, {
                                   :code => 'D'
                                 }, {
                                   :code => 'E'
                                 }, {
                                   :code => 'FPP'
                                 }, {
                                   :code => 'IT_IS_SECRET'
                                 }
                               ])
    end
  end
end
