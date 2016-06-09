class UpdateQuiz < ActiveRecord::Migration
  def up
    old_quiz = Quiz.active
    new_quiz = Quiz.create(name: 'Style Quiz')
    q1 = new_quiz.questions.create(text: "Choose the look that's closest to your everyday style?", position: "1002", step: 2,partial: "outfits",multiple: true)
    q2 = new_quiz.questions.create(text: "You're walking the red carpet. Which dress would you wear?", position: "1001", step: 1,partial: "oscar_dresses",multiple: true)
    q3 = new_quiz.questions.create(text: "It's time to dress up. Which best describes your style.", position: "1004", step: 4,:partial => "style_words",:multiple => true)
    q4 = new_quiz.questions.create(text: "Tell us which makeup look you love.",position: "1005", step: 5,:partial => "prom_makeup",:multiple => true)
    q5 = new_quiz.questions.create(text: "Whether it works for you or not, which hair style do you love?",position: "1006", step: 6,:partial => "prom_hair",:multiple => true)
    q6 = new_quiz.questions.create(text: "Which of these runway looks would inspire your dream formal dress?",position: "1007", step: 7,:partial => "prom_dresses",:multiple => true)
    q7 = new_quiz.questions.create(text: "How important is fashion to you?",position: "1008", step: 8,:partial => "fashionability",:multiple => false)
    q8 = new_quiz.questions.create(text: "Do you prefer to show some skin or to cover up? Rank how sexy you like to look.",position: "1009", step: 9,:position => "1009",:partial => "sexiness")
    q9 = new_quiz.questions.create(text: "What is your hair colour?",position: "1010", step: 10,:partial => "hair_colours",:multiple => false,:populate => "hair_colour")
    q10 = new_quiz.questions.create(text: "What is your skin colour?",position: "1011", step: 10,:partial => "skin_colours",:multiple => false,:populate => "skin_colour")
    q11 = new_quiz.questions.create(text: "What is your body shape?",position: "1012", step: 11,:partial => "body_shapes",:multiple => false,:populate => "body_shape")

    new_q3 = new_quiz.questions.create(text: "Which colors do you like to wear?", position: "1003", partial: "which_colors", multiple: true, step: 3)
    ['black','blue','blush','green','nude','pink','print','purple','red','silver','white','yellow'].each do |c|
      new_q3.answers.create(code: c)
    end

    new_q12 = new_quiz.questions.create(text: "What is your dress size?", position: "1013", partial: "dress_size", multiple: false, step: 11)
    ['US 0','US 2','US 4','US 6','US 8','US 10','US 12','US 14','US 16','US 18','US 20','US 22'].each do |s|
      new_q12.answers.create(code: s)
    end

    new_q13 = new_quiz.questions.create(text: "How tall are you?", position: "1014", partial: "how_tall", multiple: false, step: 11)
    ['Petite','Standard','Tall'].each do |h|
      new_q13.answers.create(code: h)
    end

    old_q1 = old_quiz.questions.where(text: "Choose the look that's closest to your everyday style?").first
    old_q1.answers.each do |ans|
      if ["boho1","boho2","boho3","classic1","classic2","classic3","edgy1","edgy2","edgy3","girly1","girly2","girly3","glam1","glam2","glam3"].include?(ans.code)
        q1.answers.create(code: ans.code,glam: ans.glam, girly: ans.girly,classic: ans.classic,edgy: ans.edgy, bohemian: ans.bohemian,sexiness: ans.sexiness,fashionability: ans.fashionability)
      end
    end

    old_q2 = old_quiz.questions.where(text: "You're walking the red carpet. Which dress would you wear?").first
    old_q2.answers.each do |ans|
      if ["boho1","boho2","boho3","classic1","classic2","classic3","edgy1","edgy2","edgy3","girly1","girly2","girly3","glam1","glam2","glam3"].include?(ans.code)
        q2.answers.create(code: ans.code,glam: ans.glam, girly: ans.girly,classic: ans.classic,edgy: ans.edgy, bohemian: ans.bohemian,sexiness: ans.sexiness,fashionability: ans.fashionability)
      end
    end

    old_q3 = old_quiz.questions.where(text: "It's time to dress up. Which best describes your style.").first
    old_q3.answers.each do |ans|
      q3.answers.create(code: ans.code,glam: ans.glam, girly: ans.girly,classic: ans.classic,edgy: ans.edgy, bohemian: ans.bohemian,sexiness: ans.sexiness,fashionability: ans.fashionability)
    end

    old_q4 = old_quiz.questions.where(text: "Tell us which makeup look you love.").first
    old_q4.answers.each do |ans|
      if ["dramatic1","dramatic2","dramatic3","romantic1","romantic2","romantic3","edgy1","edgy2","edgy3","statement1","statement2","statement3","natural1","natural2","natural3"].include?(ans.code)
        q4.answers.create(code: ans.code,glam: ans.glam, girly: ans.girly,classic: ans.classic,edgy: ans.edgy, bohemian: ans.bohemian,sexiness: ans.sexiness,fashionability: ans.fashionability)
      end
    end

    old_q5 = old_quiz.questions.where(text: "Whether it works for you or not, which hair style do you love?").first
    old_q5.answers.each do |ans|
      if ["boho1","boho2","boho3","classic1","classic2","classic3","edgy1","edgy2","edgy3","girly1","girly2","girly3","glam1","glam2","glam3"].include?(ans.code)
        q5.answers.create(code: ans.code,glam: ans.glam, girly: ans.girly,classic: ans.classic,edgy: ans.edgy, bohemian: ans.bohemian,sexiness: ans.sexiness,fashionability: ans.fashionability)
      end
    end

    old_q6 = old_quiz.questions.where(text: "Which of these runway looks would inspire your dream formal dress?").first
    old_q6.answers.each do |ans|
      if ["boho1","boho2","boho3","classic1","classic2","classic3","edgy1","edgy2","edgy3","girly1","girly2","girly3","glam1","glam2","glam3"].include?(ans.code)
        q6.answers.create(code: ans.code,glam: ans.glam, girly: ans.girly,classic: ans.classic,edgy: ans.edgy, bohemian: ans.bohemian,sexiness: ans.sexiness,fashionability: ans.fashionability)
      end
    end

    old_q7 = old_quiz.questions.where(text:  "How important is fashion to you?").first
    old_q7.answers.each do |ans|
      q7.answers.create(code: ans.code,glam: ans.glam, girly: ans.girly,classic: ans.classic,edgy: ans.edgy, bohemian: ans.bohemian,sexiness: ans.sexiness,fashionability: ans.fashionability)
    end

    old_q8 = old_quiz.questions.where(text:  "Do you prefer to show some skin or to cover up? Rank how sexy you like to look.").first
    old_q8.answers.each do |ans|
      if ["sxs1","sxs2","sxs3","sxs4","sxs5"].include?(ans.code)
        q8.answers.create(code: ans.code,glam: ans.glam, girly: ans.girly,classic: ans.classic,edgy: ans.edgy, bohemian: ans.bohemian,sexiness: ans.sexiness,fashionability: ans.fashionability)
      end
    end

    old_q9 = old_quiz.questions.where(text: "What is your hair colour?").first
    old_q9.answers.each do |ans|
      q9.answers.create(code: ans.code,glam: ans.glam, girly: ans.girly,classic: ans.classic,edgy: ans.edgy, bohemian: ans.bohemian,sexiness: ans.sexiness,fashionability: ans.fashionability)
    end

    old_q10 = old_quiz.questions.where(text: "What is your skin colour?").first
    old_q10.answers.each do |ans|
      q10.answers.create(code: ans.code,glam: ans.glam, girly: ans.girly,classic: ans.classic,edgy: ans.edgy, bohemian: ans.bohemian,sexiness: ans.sexiness,fashionability: ans.fashionability)
    end

    old_q11 = old_quiz.questions.where(text: "What is your body shape?").first
    old_q11.answers.each do |ans|
      q11.answers.create(code: ans.code,glam: ans.glam, girly: ans.girly,classic: ans.classic,edgy: ans.edgy, bohemian: ans.bohemian,sexiness: ans.sexiness,fashionability: ans.fashionability)
    end
  end

  def down
  end
end
