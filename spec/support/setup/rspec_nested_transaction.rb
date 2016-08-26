# rspec_nested_transactions allows using database save points instead of cleaning everything inside a transaction,
# keeping isolated tests and avoids cleaning up after each transaction.
# More docs on `rspec_nested_transaction` gem on its README: https://github.com/rosenfeld/rspec_nested_transactions

RSpec.configure do |config|

  # APPROACH 3



  # APPROACH 1

  # config.nested_transaction do |example_or_group, run|
  #   ActiveRecord::Base.transaction(requires_new: true) do
  #     run[]
  #     raise ActiveRecord::Rollback
  #   end
  # end


  # APPROACH 2

  # config.before(:all) do
  #   ActiveRecord::Base.connection.execute 'BEGIN;'
  #   ActiveRecord::Base.connection.execute 'SAVEPOINT rspec_transaction;'
  # end

  # config.after(:all) do
  #   ActiveRecord::Base.connection.execute('ROLLBACK TO SAVEPOINT rspec_transaction;')
  # end


  # config.nested_transaction do |example_or_group, run|
  #   # (run[]; next) unless example_or_group.metadata[:db] # or delete this line if you don't care
  #   ActiveRecord::Base.transaction(requires_new: true) do
  #     run[]
  #     raise ActiveRecord::Rollback
  #   end
  # end
end
