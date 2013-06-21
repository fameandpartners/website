# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)


#Spree::Core::Engine.load_seed if defined?(Spree::Core)
#Spree::Auth::Engine.load_seed if defined?(Spree::Auth)


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
                         }, {
                           :text => 'Which of these nail colours do you regularly wear?',
                           :position => 1009,
                           :multiple => true,
                           :partial => 'nail_colours',
                           :populate => 'colors'
                         }, {
                           :text => 'How important is fashion to you?',
                           :position => 1010,
                           :partial => 'fashionability'
                         }, {
                           :text => 'Do you prefer to show some skin or to cover up? Rank how sexy you like to look.',
                           :position => 1011,
                           :partial => 'sexiness'
                         }, {
                           :text => 'Do you loathe or love any of these current fashion trends?',
                           :position => 1012,
                           :partial => 'trends'
                         }, {
                           :test => 'What is your hair colour?',
                           :position => 1013,
                           :partial => 'hair_colours'
                         }, {
                           :test => 'What is your skin colour?',
                           :position => 1014,
                           :partial => 'skin_colours'
                         }, {
                           :test => 'What is your body shape?',
                           :position => 1015,
                           :partial => 'body_shapes'
                         }, {
                           :test => 'What is your typical size?',
                           :position => 1016,
                           :partial => 'typical_sizes'
                         }, {
                           :test => 'What is your bra size?',
                           :position => 1017,
                           :partial => 'bra_sizes'
                         }
                       ])


question = quiz.questions.find_by_partial!('outfits')
question.answers.create!([
                           {
                             :code => 'img1',
                             :glam => 1
                           }, {
                             :code => 'img2',
                             :classic => 1
                           }, {
                             :code => 'img3',
                             :girly => 1
                           }, {
                             :code => 'img4',
                             :bohemian => 1
                           }, {
                             :code => 'img5',
                             :edgy => 1
                           }
                         ])


question = quiz.questions.find_by_partial!('oscar_dresses')
question.answers.create!([
                           {
                             :code => 'img1',
                             :glam => 1
                           }, {
                             :code => 'img2',
                             :classic => 1
                           }, {
                             :code => 'img3',
                             :girly => 1
                           }, {
                             :code => 'img4',
                             :bohemian => 1
                           }, {
                             :code => 'img5',
                             :edgy => 1
                           }
                         ])


question = quiz.questions.find_by_partial!('style_words')
question.answers.create!([
                           {
                             :code => 'edgy',
                             :edgy => 1
                           }, {
                             :code => 'conservative',
                             :classic => 1
                           }, {
                             :code => 'bohemian',
                             :bohemian => 1
                           }, {
                             :code => 'emo',
                             :edgy => 1
                           }, {
                             :code => 'earthy',
                             :bohemian => 1
                           }, {
                             :code => 'glamorous',
                             :glam => 1
                           }, {
                             :code => 'high_fashion',
                             :glam => 1
                           }, {
                             :code => 'classic',
                             :classic => 1
                           }, {
                             :code => 'clashy',
                             :edgy => 1
                           }, {
                             :code => 'sophisticated',
                             :glam => 1
                           }, {
                             :code => 'grown_up',
                             :classic => 1
                           }, {
                             :code => 'girly',
                             :girly => 1
                           }, {
                             :code => 'feminine',
                             :girly => 1
                           }, {
                             :code => 'elegant',
                             :classic => 1
                           }, {
                             :code => 'hot',
                             :glam => 1
                           }, {
                             :code => 'sweet',
                             :girly => 1
                           }, {
                             :code => 'structured',
                             :glam => 1,
                             :edgy => 1,
                             :classic => 1
                           }, {
                             :code => 'relaxed',
                             :glam => 1,
                             :bohemian => 1,
                             :classic => 1
                           }, {
                             :code => 'understated',
                             :glam => 1,
                             :girly => 1,
                             :bohemian => 1,
                             :classic => 1
                           }, {
                             :code => 'cool',
                             :bohemian => 1,
                             :edgy => 1
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
                             :glam => 1
                           }, {
                             :code => 'jil_sander',
                             :edgy => 1
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
                             :code => 'img1',
                             :glam => 1
                           }, {
                             :code => 'img2',
                             :classic => 1
                           }, {
                             :code => 'img3',
                             :girly => 1
                           }, {
                             :code => 'img4',
                             :bohemian => 1
                           }, {
                             :code => 'img5',
                             :edgy => 1
                           }
                         ])


question = quiz.questions.find_by_partial!('prom_makeup')
question.answers.create!([
                           {
                             :code => 'img1',
                             :glam => 1
                           }, {
                             :code => 'img2',
                             :classic => 1
                           }, {
                             :code => 'img3',
                             :girly => 1
                           }, {
                             :code => 'img4',
                             :bohemian => 1
                           }, {
                             :code => 'img5',
                             :edgy => 1
                           }
                         ])


question = quiz.questions.find_by_partial!('prom_hair')
question.answers.create!([
                           {
                             :code => 'img1',
                             :glam => 1
                           }, {
                             :code => 'img2',
                             :classic => 1
                           }, {
                             :code => 'img3',
                             :girly => 1
                           }, {
                             :code => 'img4',
                             :bohemian => 1
                           }, {
                             :code => 'img5',
                             :edgy => 1
                           }
                         ])


question = quiz.questions.find_by_partial!('prom_dresses')
question.answers.create!([
                           {
                             :code => 'img1',
                             :glam => 1
                           }, {
                             :code => 'img2',
                             :classic => 1
                           }, {
                             :code => 'img3',
                             :girly => 1
                           }, {
                             :code => 'img4',
                             :bohemian => 1
                           }, {
                             :code => 'img5',
                             :edgy => 1
                           }
                         ])


question = quiz.questions.find_by_partial!('nail_colours')
question.answers.create!([
                           {
                             :code => 'neon_yellow',
                             :glam => 4,
                             :edgy => 6,
                             :bohemian => 3
                           }, {
                             :code => 'neutral',
                             :girly => 6,
                             :classic => 8
                           }, {
                             :code => 'mint',
                             :girly => 3,
                             :edgy => 3,
                             :bohemian => 3
                           }, {
                             :code => 'navy',
                             :glam => 5,
                             :edgy => 3,
                             :bohemian => 3,
                             :classic => 3
                           }, {
                             :code => 'black',
                             :glam => 5,
                             :edgy => 5,
                             :bohemian => 7
                           }, {
                             :code => 'glittery',
                             :glam => 2,
                             :girly => 5,
                             :edgy => 5
                           }, {
                             :code => 'lilac',
                             :girly => 8,
                             :classic => 2
                           }, {
                             :code => 'light_pink',
                             :girly => 8,
                             :classic => 6
                           }, {
                             :code => 'french_tip',
                             :girly => 6,
                             :classic => 8
                           }, {
                             :code => 'gold',
                             :glam => 5,
                             :edgy => 5,
                             :classic => 3
                           }, {
                             :code => 'purple',
                             :edgy => 2,
                             :bohemian => 5
                           }, {
                             :code => 'bright_red',
                             :glam => 7,
                             :edgy => 3
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

question = quiz.questions.find_by_partial!('trends')
question.answers.create!([
                           {
                             :code => 'jewel_tones'
                           }, {
                             :code => 'volumnious_skirts'
                           }, {
                             :code => 'sequins'
                           }, {
                             :code => 'neon'
                           }, {
                             :code => 'lace_and_mesh'
                           }, {
                             :code => 'applique'
                           }, {
                             :code => 'digital_prints'
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

question = quiz.questions.find_by_partial!('typical_sizes')
question.answers.create!([
                           {
                             :code => 'G0'
                           }, {
                             :code => 'G2'
                           }, {
                             :code => 'G4'
                           }, {
                             :code => 'G6'
                           }, {
                             :code => 'G8'
                           }, {
                             :code => 'G12'
                           }, {
                             :code => 'G14'
                           }, {
                             :code => 'L4'
                           }, {
                             :code => 'L6'
                           }, {
                             :code => 'L8'
                           }, {
                             :code => 'L10'
                           }, {
                             :code => 'L12'
                           }, {
                             :code => 'L14'
                           }, {
                             :code => 'L16'
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
                             :code => 'c'
                           }, {
                             :code => 'D'
                           }, {
                             :code => 'E'
                           }, {
                             :code => 'FPP'
                           }
                         ])
