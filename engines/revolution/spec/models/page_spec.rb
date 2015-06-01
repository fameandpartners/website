require 'spec_helper'

describe Revolution::Page do

  let(:path)      { '/blah/vtha' }
  let(:title)     { 'Blah Vtha' }

  subject!(:page)  { Revolution::Page.create!(:path => path) }

  it { is_expected.to validate_presence_of :path }


  context 'when a path is changed' do
    before do
      page.path = '/vtha/blah'
    end

    it { is_expected.to be_invalid }

    it 'should be invalid' do
      page.valid?
      expect(page.errors).to include(:path)
    end
  end

  describe 'find_for' do
    it 'should handle multiple paths' do
      found = Revolution::Page.find_for('/aguirre','/blah/vtha')
      expect(found).to eq page
    end

    it 'short-circuit if page found' do
      page #apparently this does not exist
      binding.pry
      expect(Revolution::Page).to_not receive(:find_by_path).with('/aguirre')
      found = Revolution::Page.find_for('/blah/vtha','/aguirre')
      expect(found).to eq page
    end
  end

  describe 'Parent/Childs' do

    let(:child_page)  { Revolution::Page.create!(:parent => page, :path => "#{path}/vtha") }

    before do
      page.reload
    end

    it { expect(child_page.parent).to eq page }
    it { expect(page.children_count).to eq 1 }
    it { expect(child_page.depth).to eq 1 }

  end

  describe 'translations' do
    let!(:translation)  { page.translations.create!(:locale => locale, :title => title, :meta_description => title) }

    context 'with locale translation' do
      let(:locale)    { 'en-AU' }

      it 'should have a translation' do
        expect(page.translations.find_for_locale(locale)).to eq translation
      end
    end

    context 'without locale translation' do
      let(:locale)    { 'en-US' }
      it 'should have a translation' do
        expect(page.translations.find_for_locale('en-VTHA')).to eq translation
      end
    end
  end

end
