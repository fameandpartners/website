require "spec_helper"

describe LandingPage::ProductRepository do
  let(:repo)  { LandingPage::ProductRepository.new }
  
  it 'works' do
    repo.products
  end


end