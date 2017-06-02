class ContentfulRoute < ActiveRecord::Base
  attr_accessible :route_name, :action
  # attr_accessible :title, :body
end

# @user = User.create({:route_name => "My name", :action => "nice_user"})
