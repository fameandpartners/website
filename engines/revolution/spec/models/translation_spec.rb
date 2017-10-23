require 'spec_helper'

describe Revolution::Translation do
  let(:path)      { '/blah/vtha' }
  let(:locale)    { 'en-AU' }
  let(:title)     { 'Blah Vtha' }

  let(:page) { Revolution::Page.new(path: path) }

  subject(:translation) { Revolution::Translation.new(page: page, locale: locale, title: title) }

  it { should belong_to(:page).inverse_of(:translations) }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :locale }
  it { is_expected.to validate_presence_of :page }
  it { is_expected.to validate_presence_of :meta_description }
end
