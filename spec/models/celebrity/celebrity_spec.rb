require 'spec_helper'

describe Celebrity do
  describe "it must have a kind field" do
  	it "must have a default of 'celebrity' as a kind" do
  		c = Celebrity.new

  		c.kind.should_equal 'celebrity'
  	end

  end
end