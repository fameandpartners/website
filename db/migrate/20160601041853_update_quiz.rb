class UpdateQuiz < ActiveRecord::Migration
  def up
    q1 = Quiz.active.questions.where(text: "Choose the look that's closest to your everyday style?").first
    q2 = Quiz.active.questions.where(text: "You're walking the red carpet. Which dress would you wear?").first
    q3 = Quiz.active.questions.where(text: "It's time to dress up. Which best describes your style.").first
    q4 = Quiz.active.questions.where(text: "Tell us which makeup look you love.").first
    q5 = Quiz.active.questions.where(text: "Whether it works for you or not, which hair style do you love?").first
    q6 = Quiz.active.questions.where(text: "Which of these runway looks would inspire your dream formal dress?").first
    q7 = Quiz.active.questions.where(text: "How important is fashion to you?").first
    q8 = Quiz.active.questions.where(text: "Do you prefer to show some skin or to cover up? Rank how sexy you like to look.").first
    q9 = Quiz.active.questions.where(text: "What is your hair colour?").first
    q10 = Quiz.active.questions.where(text: "What is your skin colour?").first
    q11 = Quiz.active.questions.where(text: "What is your body shape?").first

    q1.update_column(:position, "1002")
    q1.update_column(:step, 2)
    q2.update_column(:position, "1001")
    q2.update_column(:step, 1)
    q3.update_column(:position, "1004")
    q3.update_column(:step, 4)
    q4.update_column(:position, "1005")
    q4.update_column(:step, 5)
    q5.update_column(:position, "1006")
    q5.update_column(:step, 6)
    q6.update_column(:position, "1007")
    q6.update_column(:step, 7)
    q7.update_column(:position, "1008")
    q7.update_column(:step, 8)
    q8.update_column(:position, "1009")
    q8.update_column(:step, 9)
    q9.update_column(:position, "1010")
    q9.update_column(:step, 10)
    q10.update_column(:position, "1011")
    q10.update_column(:step, 10)
    q11.update_column(:position, "1012")
    q11.update_column(:step, 11)

    q1.answers.where('code NOT IN (?)', ["boho1","boho2","boho3","classic1","classic2","classic3","edgy1","edgy2","edgy3","girly1","girly2","girly3","glam1","glam2","glam3"]).delete_all
    q2.answers.where('code NOT IN (?)', ["boho1","boho2","boho3","classic1","classic2","classic3","edgy1","edgy2","edgy3","girly1","girly2","girly3","glam1","glam2","glam3"]).delete_all
    q4.answers.where('code NOT IN (?)', ["dramatic1","dramatic2","dramatic3","romantic1","romantic2","romantic3","edgy1","edgy2","edgy3","statement1","statement2","statement3","natural1","natural2","natural3"]).delete_all
    q5.answers.where('code NOT IN (?)', ["boho1","boho2","boho3","classic1","classic2","classic3","edgy1","edgy2","edgy3","girly1","girly2","girly3","glam1","glam2","glam3"]).delete_all
    q6.answers.where('code NOT IN (?)', ["boho1","boho2","boho3","classic1","classic2","classic3","edgy1","edgy2","edgy3","girly1","girly2","girly3","glam1","glam2","glam3"]).delete_all

    q8.answers.where('sexiness > 5').delete_all
    new_q3 = Quiz.active.questions.create(text: "Which colors do you like to wear?", position: "1003", partial: "which_colors", multiple: true, step: 3)
    new_q12 = Quiz.active.questions.create(text: "What is your dress size?", position: "1013", partial: "dress_size", multiple: false, step: 11)
    new_q13 = Quiz.active.questions.create(text: "How tall are you?", position: "1014", partial: "how_tall", multiple: false, step: 11)
  end

  def down
  end
end
