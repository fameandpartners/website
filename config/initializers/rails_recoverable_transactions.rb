raise "Remove monkey patch in #{__FILE__}" if Rails::VERSION::MAJOR > 4

module TransactionRecoverable
  module ClassMethods
    def transaction(*args)
      super(*args) do
        yield
      end
    rescue PG::InFailedSqlTransaction
      connection.rollback_db_transaction
      connection.clear_cache!

      super(*args) do
        yield
      end
    end
  end
end

class << ActiveRecord::Base
  prepend TransactionRecoverable::ClassMethods
end