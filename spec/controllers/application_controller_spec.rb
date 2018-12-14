require 'spec_helper'

describe ApplicationController, :type => :controller do
  controller do
    def index
      render :text => 'ok'
    end

    def create
      render :text => 'ok'
    end
  end
end
