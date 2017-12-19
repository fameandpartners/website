require 'spec_helper'

describe 'size guide spec', type: :feature do

  it 'displays the page' do
  	configatron.temp do
	  configatron.node_pdp_url = 'https://content-dev2.fameandgroups.com'
	
	    visit '/size-guide'

	    expect(page).to have_selector("h2:contains('Size guide')")
	    expect(page).to have_content('All our styles now follow our brand new size guide, which makes it ' \
	                                 'easier than ever to create a dress with an absolutely flawless ' \
	                                 'fit. If you\'ve shopped with us before, your size may have changed.')
	    expect(page).to have_selector('table.size-guide')
    end
  end
end
