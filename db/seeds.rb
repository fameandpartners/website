# encoding: utf-8

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

quiz.questions.create([
                        {
                          :text => 'Which outfit below would you most want to wear?',
                          :position => 1001,
                          :partial => 'outfits'
                        }, {
                          :text => 'Which dress would you choose to walk the red carpet at the Oscars?',
                          :position => 1002,
                          :partial => 'oscar_dresses'
                        }, {
                          :text => 'When you’re getting dressed up, which of these best describes your fashion style?',
                          :position => 1003,
                          :multiple => true,
                          :partial => 'style_words'
                        }, {
                          :text => 'Which brands speak to your style?',
                          :position => 1004,
                          :multiple => true,
                          :partial => 'brands'
                        }, {
                          :text => 'Which shoes would you wear to your prom?',
                          :position => 1005,
                          :partial => 'prom_shoes'
                        }, {
                          :text => 'What type of makeup would you love to wear to prom?',
                          :position => 1006,
                          :partial => 'prom_makeup'
                        }, {
                          :text => 'If you could have any celebrity’s hair, which of these would you so love to wear to prom?',
                          :position => 1007,
                          :partial => 'prom_hair'
                        }, {
                          :text => 'Which of these runway dresses would you want to borrow inspiration from, for your prom look?',
                          :position => 1008,
                          :partial => 'prom_dresses'
                        }, {
                          :text => 'Which of these nail colours do you wear regularly?',
                          :position => 1009,
                          :multiple => true,
                          :partial => 'nail_colours'
                        }, {
                          :text => 'How do you rate your fashionability?',
                          :position => 1010,
                          :partial => 'fashionability'
                        }, {
                          :text => 'How sexy do you want your Prom Dress?',
                          :position => 1011,
                          :partial => 'sexiness'
                        }
                      ])


question = quiz.questions.find_by_partial('outfits')
question.answers.create([
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


question = quiz.questions.find_by_partial('oscar_dresses')
question.answers.create([
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


question = quiz.questions.find_by_partial('style_words')
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


question = quiz.questions.find_by_partial('brands')
question.answers.create([
                          {
                            :code => 'chanel',
                            :glam => 0.5,
                            :classic => 0.5
                          }, {
                            :code => 'burberry',
                            :edgy => 0.25,
                            :bohemian => 0.25,
                            :classic => 0.5
                          }, {
                            :code => 'lavin',
                            :glam => 0.5,
                            :edgy => 0.25,
                            :bohemian => 0.25
                          }, {
                            :code => 'christian_dior',
                            :glam => 1
                          }, {
                            :code => 'jil_sander',
                            :edgy => 1
                          }, {
                            :code => 'zuhair_murad',
                            :glam => 0.5,
                            :bohemian => 0.5
                          }, {
                            :code => 'gucci',
                            :glam => 0.5,
                            :edgy => 0.5
                          }, {
                            :code => 'sass_bide',
                            :edgy => 0.5,
                            :bohemian => 0.5
                          }, {
                            :code => 'miu_miu',
                            :glam => 0.25,
                            :girly => 0.5,
                            :classic => 0.25
                          }, {
                            :code => 'chloe',
                            :girly => 0.25,
                            :edgy => 0.5,
                            :classic => 0.25
                          }, {
                            :code => 'kate_spade',
                            :girly => 0.5,
                            :classic => 0.5
                          }, {
                            :code => 'ralph_lauren',
                            :girly => 0.25,
                            :classic => 0.75
                          }
                        ])


question = quiz.questions.find_by_partial('prom_shoes')
question.answers.create([
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


question = quiz.questions.find_by_partial('prom_makeup')
question.answers.create([
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


question = quiz.questions.find_by_partial('prom_hair')
question.answers.create([
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


question = quiz.questions.find_by_partial('prom_dresses')
question.answers.create([
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


question = quiz.questions.find_by_partial('nail_colours')
question.answers.create([
                          {
                            :code => 'neon_yellow',
                            :glam => 0.4,
                            :edgy => 0.6,
                            :bohemian => 0.3
                          }, {
                            :code => 'neutral',
                            :girly => 0.6,
                            :classic => 0.8
                          }, {
                            :code => 'mint',
                            :girly => 0.25,
                            :edgy => 0.25,
                            :bohemian => 0.25
                          }, {
                            :code => 'navy',
                            :glam => 0.5,
                            :edgy => 0.25,
                            :bohemian => 0.25,
                            :classic => 0.25
                          }, {
                            :code => 'black',
                            :glam => 0.25,
                            :edgy => 0.5,
                            :bohemian => 0.75
                          }, {
                            :code => 'glittery',
                            :glam => 0.2,
                            :girly => 0.5,
                            :edgy => 0.5
                          }, {
                            :code => 'lilac',
                            :girly => 0.8,
                            :classic => 0.2
                          }, {
                            :code => 'light_pink',
                            :girly => 0.8,
                            :classic => 0.6
                          }, {
                            :code => 'french_tip',
                            :girly => 0.6,
                            :classic => 0.8
                          }, {
                            :code => 'gold',
                            :glam => 0.5,
                            :edgy => 0.5,
                            :classic => 0.25
                          }, {
                            :code => 'purple',
                            :edgy => 0.2,
                            :bohemian => 0.5
                          }, {
                            :code => 'bright_red',
                            :glam => 0.7,
                            :edgy => 0.3
                          }
                        ])


question = quiz.questions.find_by_partial('fashionability')
question.answers.create([
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



question = quiz.questions.find_by_partial('sexiness')
question.answers.create([
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
