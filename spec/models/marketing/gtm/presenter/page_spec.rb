require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe Page, type: :presenter do
        let(:type) { 'product' }
        let(:meta_description) { 'Super Dress is awesome' }
        let(:title) { 'Super Dress' }
        let(:url) { 'http://lvh.me/super-dress' }

        subject(:presenter) { described_class.new(type: type, meta_description: meta_description, title: title, url: url) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          context 'given a type, meta description, title and url' do
            it 'returns hash given data' do
              expect(subject.body).to eq({
                                             type:            'product',
                                             metaDescription: meta_description,
                                             title:           title,
                                             url:             url
                                         })
            end
          end
        end
      end
    end
  end
end
