class UpdateCompetition < ActiveRecord::Migration
  def up
    add_column_if_not_exists :competition_entries,      :competition_name,  :string
    add_column_if_not_exists :competition_entries,      :competition_id,    :integer
    add_column_if_not_exists :competition_invitations,  :competition_name,  :string
    add_column_if_not_exists :competition_invitations,  :competition_id,    :integer

    Competition::Entry.where(competition_name: nil).update_all(
      competition_name: 'celebrity_formal_outfit'
    )
    Competition::Invite.where(competition_name: nil).update_all(
      competition_name: 'celebrity_formal_outfit'
    )
  end

  def down
    # if we remove competition name, we will lost data, required to 
    # distinguish old and current competition.
  end

  def add_column_if_not_exists(table_name, column_name, column_type)
    if !column_exists?(table_name, column_name, column_type)
      add_column table_name, column_name, column_type
    end
  end
end
