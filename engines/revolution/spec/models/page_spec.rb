require 'spec_helper'

describe Revolution::Page do

  let(:path)      { '/blah/vtha' }
  let(:title)     { 'Blah Vtha' }

  subject!(:page)  { Revolution::Page.create!(:path => path) }

  it { is_expected.to validate_presence_of :path }

  describe 'Publishing' do

    context 'when published' do
      before do
        page.publish!
      end
      it 'is published' do
        expect(page).to be_published
        expect(Revolution::Page.published.all).to include(page)
      end
    end

    context 'when not published' do
      it 'is not published' do
        expect(page).to_not be_published
        expect(Revolution::Page.published.all).to be_empty
      end
    end

    context 'when published after now' do
      before do
        page.update_attributes(:publish_from => 2.days.since)
      end

      it 'is not published' do
        expect(page).to_not be_published
        expect(Revolution::Page.published.all).to eq []
      end
    end

    context 'when publication has expired' do
      before do
        page.update_attributes(:publish_from => 7.days.ago, :publish_to => 1.days.ago)
      end

      it 'is not published' do
        expect(page).to_not be_published
        expect(Revolution::Page.published.all).to eq []
      end
    end
  end

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
    context 'published' do
      before do
        page.publish!(1.day.ago)
      end
      it 'should handle multiple paths' do
        found = Revolution::Page.find_for('/aguirre','/blah/vtha')
        expect(found).to eq page
      end
    end

    context 'not published' do
      it 'should find no thing' do
        expect(Revolution::Page.find_for('/blah/vtha')).to be_blank
      end
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
