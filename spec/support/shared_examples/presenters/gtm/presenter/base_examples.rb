RSpec.shared_examples 'a Marketing::Gtm::Presenter::Base' do
  it { is_expected.to respond_to(:key) }
  it { is_expected.to respond_to(:body) }

  describe '#rescuable_body' do
    before(:each) do
      allow(subject).to receive(:body).and_raise(StandardError, 'With a message')
    end

    it 'returns a hash with :error as key and error message as value' do
      expect(subject.rescuable_body).to eq({ error: 'With a message' })
    end
  end
end
