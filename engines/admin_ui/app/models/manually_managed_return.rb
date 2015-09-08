class ManuallyManagedReturn < ActiveRecord::Base

  attr_accessible(*self.new.attributes.keys
                     .reject{|x| %w(id created_at updated_at).include?(x) }
                     .collect(&:to_sym))

end
