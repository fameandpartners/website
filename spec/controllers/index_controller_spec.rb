require 'spec_helper'
describe IndexController, :type => :controller do
  describe 'GET :show' do
    before { get :show }

    it { should respond_with :success }
  end
end