require 'spec_helper'

# Using the index controller here is not great,
# I just wanted a way to hit the application default layout.
# RSpec.describe IndexController, :type => :controller do
#   describe 'sitewide partials' do
#     render_views
#     it do
#       get :show
#       expect(response).to render_template(:partial => 'layouts/redesign/_javascript')
#     end
#   end
# end
