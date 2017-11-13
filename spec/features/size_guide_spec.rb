require 'spec_helper'

xdescribe 'size guide spec', type: :feature do
  it 'displays the page' do
    visit '/size-guide'

    expect(page).to have_selector("h2:contains('Size guide')")
    expect(page).to have_content('All our styles now follow our brand new size guide, which makes it ' \
                                 'easier than ever to create a dress with an absolutely flawless ' \
                                 'fit. If you\'ve shopped with us before, your size may have changed.')
    expect(page).to have_selector('table.size-guide')
  end
end
