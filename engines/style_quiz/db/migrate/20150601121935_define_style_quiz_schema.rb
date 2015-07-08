class DefineStyleQuizSchema < ActiveRecord::Migration
  def change
    create_table :style_quiz_questions, force: true do |t|
      t.boolean :active, default: true
      t.string  :code
      t.string  :name
      t.string  :template
      t.integer :position
    end

    create_table :style_quiz_answers, force: true do |t|
      t.references :question
      t.boolean :active, default: true
      t.string  :group
      t.string  :name
      t.string  :value
      t.string  :image
      t.integer :position
      t.string  :tags
    end

    create_table :style_quiz_tags, force: true do |t|
      t.string :group
      t.string :name
    end

    create_table :style_quiz_user_profiles, force: true do |t|
      t.references  :user
      t.string      :token
      t.string      :email
      t.string      :fullname
      t.date        :birthday
      t.string      :tags
      t.text        :answer_ids
      t.text        :recommendated_products
      t.datetime    :completed_at
      t.timestamps
    end

    create_table :style_quiz_user_profile_events, force: true do |t|
      t.references :user_profile
      t.string     :name
      t.string     :event_type
      t.date       :date
    end

    change_table :spree_products do |t|
      t.string :tags
    end
  end
end
