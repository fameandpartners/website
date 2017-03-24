class CreateRedirectedSearchTerms < ActiveRecord::Migration
  def change
    create_table :redirected_search_terms do |t|
      t.string :term
      t.string :redirect_to

      t.timestamps
    end
  end
end
