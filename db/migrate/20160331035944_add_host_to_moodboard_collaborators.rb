class AddHostToMoodboardCollaborators < ActiveRecord::Migration
  def up
    Moodboard.all.each do |m|
      if m.collaborators.size > 0
        m.collaborators.create(name: m.user.first_name, email: m.user.email)
      end
    end
  end

  def down
    #NOOP
  end
end
