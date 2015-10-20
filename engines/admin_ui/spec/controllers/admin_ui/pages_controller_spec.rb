require 'rails_helper'

module AdminUi
  module Content
    RSpec.describe PagesController, :type => :controller do

      routes { AdminUi::Engine.routes }

      describe "GET index" do
        let!(:page) { Revolution::Page.create(path: "/dresses/Test") }

        it "finds a entry in pages when giving a search parameter" do
          get :index, search: "Test"
          expect(@controller.send(:collection)[0]).to eql(page)
        end

        it "finds a entry in pages when giving a search parameter in a different case" do
          get :index, search: "test"
          expect(@controller.send(:collection)[0]).to eql(page)
        end

        it "does not find an entry in pages when giving a search parameter not pages" do
          get :index, search: "un-test"
          expect(@controller.send(:collection)).to be_empty
        end

        it "finds all entries in pages when giving an empty search parameter" do
          get :index, search: ""
          all_count = Revolution::Page.count
          expect(@controller.send(:collection).size).to eql(all_count)
        end
      end

    end
  end
end

