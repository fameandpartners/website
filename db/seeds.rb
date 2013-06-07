# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#Spree::Core::Engine.load_seed if defined?(Spree::Core)
#Spree::Auth::Engine.load_seed if defined?(Spree::Auth)


quiz = Quiz.create(:name => 'Style Quiz')

question = quiz.questions.create({
                                   :text => 'Which outfit below would you most want to wear?',
                                   :position => 1,
                                   :partial => 'first'
                                 })
question.answers.create([
                         {
                           :code => 'img1',
                           :glam => 0.6,
                           :girly => 0.4
                         },
                         {
                           :code => 'img2',
                           :classic => 0.7,
                           :edgy => 0.3
                         },
                         {
                           :code => 'img3',
                           :girly => 0.2,
                           :edgy => 0.8
                         },
                         {
                           :code => 'img4',
                           :bohemian => 0.6,
                           :edgy => 0.4
                         },
                         {
                           :code => 'img5',
                           :girly => 0.8,
                           :classic => 0.2
                         }
                       ])

question = quiz.questions.create({
                                   :text => 'Which dress would you choose to walk the red carpet at the Oscars?',
                                   :position => 2,
                                   :partial => 'second'
                                 })
question.answers.create([
                          {
                            :code => 'img1',
                            :classic => 0.6,
                            :girly => 0.4
                          },
                          {
                            :code => 'img2',
                            :edgy => 0.7,
                            :girly => 0.3
                          },
                          {
                            :code => 'img3',
                            :girly => 0.7,
                            :edgy => 0.3
                          },
                          {
                            :code => 'img4',
                            :glam => 0.8,
                            :edgy => 0.2
                          },
                          {
                            :code => 'img5',
                            :bohemian => 0.6,
                            :classic => 0.4
                          }
                       ])

question = quiz.questions.create({
                                   :text => 'When you’re getting dressed up, which of these best describes your fashion style?',
                                   :position => 3,
                                   :partial => 'third',
                                   :multiple => true
                                 })
question.answers.create([
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
                           :code => 'cool',
                           :bohemian => 1
                         }
])

#question = quiz.questions.create(:text => 'Which brands speak to your style?')
#question.answers.build([
#                         {
#                           :bohemian => 0.6,
#                           :girly => 0.4
#                         },
#                         {
#                           :glam => 0.7,
#                           :girly => 0.3
#                         },
#                         {
#                           :glam => 0.6,
#                           :classic => 0.4
#                         }
#                       ])
#
#question = quiz.questions.create(:text => 'Which shoes would you wear to your prom?')
#question.answers.build([
#                         {
#                           :bohemian => 0.6,
#                           :girly => 0.4
#                         },
#                         {
#                           :glam => 0.7,
#                           :girly => 0.3
#                         },
#                         {
#                           :glam => 0.6,
#                           :classic => 0.4
#                         }
#                       ])

question = quiz.questions.create({
                                   :text => 'How do you rate your fashionability?',
                                   :position => 4,
                                   :partial => 'fourth'
                                 })
question.answers.create([
                         {
                           :code => 'fsh1',
                           :fashionability => 1
                         },
                         {
                           :code => 'fsh2',
                           :fashionability => 2
                         },
                         {
                           :code => 'fsh3',
                           :fashionability => 3
                         },
                         {
                           :code => 'fsh4',
                           :fashionability => 4
                         },
                         {
                           :code => 'fsh5',
                           :fashionability => 5
                         },
                         {
                           :code => 'fsh6',
                           :fashionability => 6
                         },
                         {
                           :code => 'fsh7',
                           :fashionability => 7
                         },
                         {
                           :code => 'fsh8',
                           :fashionability => 8
                         },
                         {
                           :code => 'fsh9',
                           :fashionability => 9
                         },
                         {
                           :code => 'fsh10',
                           :fashionability => 10
                         },
                       ])

question = quiz.questions.create({
                                   :text => 'How sexy do you want your Prom Dress?',
                                   :position => 5,
                                   :partial => 'fifth',})
question.answers.create([
                         {
                           :code => 'sxs1',
                           :sexiness => 1
                         },
                         {
                           :code => 'sxs2',
                           :sexiness => 2
                         },
                         {
                           :code => 'sxs3',
                           :sexiness => 3
                         },
                         {
                           :code => 'sxs4',
                           :sexiness => 4
                         },
                         {
                           :code => 'sxs5',
                           :sexiness => 5
                         },
                         {
                           :code => 'sxs6',
                           :sexiness => 6
                         },
                         {
                           :code => 'sxs7',
                           :sexiness => 7
                         },
                         {
                           :code => 'sxs8',
                           :sexiness => 8
                         },
                         {
                           :code => 'sxs9',
                           :sexiness => 9
                         },
                         {
                           :code => 'sxs10',
                           :sexiness => 10
                         },
                       ])
