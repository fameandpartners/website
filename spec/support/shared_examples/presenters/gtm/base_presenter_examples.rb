RSpec.shared_examples 'a Marketing::Gtm::BasePresenter' do
  it { is_expected.to respond_to(:key) }
  it { is_expected.to respond_to(:body) }
  it { is_expected.to respond_to(:rescuable_body) }
end

