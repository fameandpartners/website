require 'spec_helper'

describe Revolution::Banner do
  let(:path)      { '/blah/vtha' }
  let(:locale)    { 'en-AU' }
  let(:title)     { 'Blah Vtha' }

  let(:page)  { Revolution::Page.create(path: path) }
  let!(:translation) { page.translations.create!(locale: locale, title: title, meta_description: title) }
  subject(:banner)  { Revolution::Banner.new(translation_id: translation.id,
                                                          banner_order: 1,
                                                          size: 'full',
                                                          banner_file_name: 'image1.jpg',
                                                          banner_content_type: 'image/jpeg') }

  before(:each) do
    allow(banner).to receive(:file_dimensions).and_return(true)
  end


  it { should belong_to(:translation).inverse_of(:banners) }
  it { is_expected.to validate_presence_of :banner_order }
  it { is_expected.to validate_presence_of :alt_text }
  it { is_expected.to validate_attachment_content_type(:banner).
      allowing('image/png', 'image/gif', 'image/jpeg').rejecting('text/plain', 'text/xml') }
  it { is_expected.to validate_attachment_presence(:banner) }
  it { is_expected.to have_attached_file(:banner) }
end
