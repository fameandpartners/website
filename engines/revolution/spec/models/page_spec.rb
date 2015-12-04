require 'spec_helper'

describe Revolution::Page do
  let(:path) { '/blah/vtha' }
  let(:title) { 'Blah Vtha' }

  subject(:page) { Revolution::Page.create!(:path => path) }

  it { is_expected.to validate_presence_of :path }
  it { is_expected.to validate_uniqueness_of :path }

  it { is_expected.to delegate_method(:title).to(:translation) }
  it { is_expected.to delegate_method(:meta_description).to(:translation) }

  context 'an empty translation' do
    describe 'has empty values' do
      it { expect(page.title).to be_nil }
      it { expect(page.meta_description).to be_nil }
    end
  end

  describe 'robots' do
    context 'no noindex, nofollow' do
      it { expect(page.robots).to eq 'index,follow' }
    end

    context 'noindex' do
      before do
        page.noindex = true
      end
      it { expect(page.robots).to eq 'noindex,follow' }
    end

    context 'nofollow' do
      before do
        page.nofollow = true
      end
      it { expect(page.robots).to eq 'index,nofollow' }
    end

    context 'noindex, nofollow' do
      before do
        page.noindex  = true
        page.nofollow = true
      end
      it { expect(page.robots).to eq 'noindex,nofollow' }
    end
  end

  let(:path) { '/blah/vtha' }
  let(:title) { 'Blah Vtha' }

  subject!(:page) { Revolution::Page.create!(:path => path) }

  it { is_expected.to validate_presence_of :path }

  describe '.default_page' do
    it 'should set the default path' do
      found = Revolution::Page.default_page
      expect(found.template_path).to be
    end
  end

  describe '.find_for' do
    context 'published' do
      before do
        page.publish!(1.day.ago)
      end
      it 'should handle multiple paths' do
        found = Revolution::Page.find_for('/aguirre', '/blah/vtha')
        expect(found).to eq page
      end
    end

    context 'not published' do
      it 'should find no thing' do
        expect(Revolution::Page.find_for('/blah/vtha')).to be_blank
      end
    end
  end

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

    context 'variables' do
      before do
        page.variables = {:blah => 'vtha'}
      end
      it 'returns var' do
        expect(page.get(:blah)).to eq 'vtha'
      end
      it 'returns var' do
        expect(page.get(:vtha)).to eq nil
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

  describe 'Parent/Childs' do
    let!(:child_page) { Revolution::Page.create!(:parent => page, :path => "#{path}/vtha") }

    before { page.reload }

    it { expect(child_page.parent).to eq page }
    it { expect(page.children_count).to eq 1 }
    it { expect(child_page.depth).to eq 1 }
  end

  describe 'with a collection' do
    let(:heading) { 'BLAH!' }
    let(:sub_heading) { 'VTHA!' }
    let(:collection) { double('Collection') }

    before do
      allow(page).to receive(:collection).and_return(collection)
      allow(collection).to receive_message_chain(:details, :banner, :title => heading)
      allow(collection).to receive_message_chain(:details, :banner, :subtitle => sub_heading)
    end

    context 'with collection and no translation' do
      it { expect(page.heading).to eq heading }
      it { expect(page.sub_heading).to eq sub_heading }
    end
  end

  describe 'translations' do
    let!(:translation) { page.translations.create!(:locale => locale, :title => title, :meta_description => title) }

    context 'with locale translation' do
      let(:locale) { 'en-AU' }

      it 'should have a translation' do
        expect(page.translations.find_for_locale(locale)).to eq translation
      end

      it 'should delegate to translation' do
        page.locale = locale
        expect(page.title).to eq translation.title
      end

      context 'with a collection' do
        let(:heading) { 'BLAH!' }
        let(:collection) { double('Collection') }

        before do
          allow(page).to receive(:collection).and_return(collection)
          allow(collection).to receive_message_chain(:details, :banner, :title => heading)
        end

        it 'should still delegate to translation' do
          page.locale = locale
          expect(page.title).to eq translation.title
        end
      end
    end

    context 'without locale translation' do
      let(:locale) { 'en-US' }
      it 'should have a translation' do
        expect(page.translations.find_for_locale('en-VTHA')).to eq translation
      end
    end
  end

  describe 'parameters' do
    it 'should return the parameters if it is set' do
      found        = Revolution::Page.default_page
      found.params = 'params1'
      expect(found.params).to be
    end
  end

  describe '#effective_page_limit' do
    let(:page_params)    { {} }
    let(:page_variables) { {} }
    before do
      page.variables = page_variables
      page.params    = page_params
    end

    context 'params supersede variables' do
      let(:page_params)    { {limit: 77} }
      let(:page_variables) { {limit: 99} }

      it  { expect(page.effective_page_limit).to eq 77 }
    end

    context 'variables supersede fallback' do
      let(:page_variables) { {limit: 99} }

      it  { expect(page.effective_page_limit).to eq 99 }
    end

    context 'falls back to default_page_limit' do
      it { expect(page.effective_page_limit).to eq page.default_page_limit }
    end
  end

  describe '#default_page_limit' do
    it { expect(page.default_page_limit).to eq 21 }
  end

  describe '.limit' do

    context 'given no parameter limit and no variable limit' do
      before do
        page.params = {}
      end
      it 'returns 21 when given 0 product_ids' do
        product_ids = []
        expect(page.limit(product_ids)).to eq 21
      end
      it 'returns 20 when given 1 product_ids' do
        product_ids = ["451"]
        expect(page.limit(product_ids)).to eq 20
      end
      it 'returns 0 when given 22 product_ids and no offset' do
        product_ids = ["451", '1', '2', '3', '4', '5', '6', '7', '8','9','10',
                       '11', '12', '13',' 14', '15', '16', '17', '18', '19', '20','21']
        expect(page.limit(product_ids)).to eq 0
      end
      it 'returns 20 when given 22 product_ids and an offset of 21' do
        product_ids = ['451', '1', '2', '3', '4', '5', '6', '7', '8','9','10',
                       '11', '12', '13',' 14', '15', '16', '17', '18', '19', '20','21']
        page.params = {offset: 21}
        expect(page.limit(product_ids)).to eq 20
      end
    end

    context 'given no variable limit' do
      before do
        page.params = {limit: 22}
      end
      it 'returns 22 when given 0 product_ids and a parameter limit of 22' do
        product_ids  = []
        expect(page.limit(product_ids)).to eq 22
      end
      it 'returns 20 when given 2 product_ids and a parameter limit of 22' do
        product_ids  = ['457', '2']
        expect(page.limit(product_ids)).to eq 20
      end
      it 'returns 20 when given 22 product_ids and an offset of 21 and a limit of 21' do

        product_ids = (1..22).to_a
        page.params = {offset: 21, limit: 21}
        expect(page.limit(product_ids)).to eq 20
      end
    end

    context 'given a variable limit of 23' do
      before do
        page.variables = {:limit => '23'}
        page.params    = {}
      end
      it 'returns 22 when given 0 product_ids and a parameter limit of 22' do
        page.params = {limit: 22}
        product_ids = []
        expect(page.limit(product_ids)).to eq 22
      end
      it 'returns 23 when given 0 product_ids and no parameter limit' do
        product_ids = []
        expect(page.limit(product_ids)).to eq 23
      end
      it 'returns 21 when given 2 product_ids and no parameter limit' do
        product_ids = ['457', '2']
        expect(page.limit(product_ids)).to eq 21
      end

      it 'more products than the limit' do
        product_ids = (1..30).to_a
        expect(page.limit(product_ids)).to eq 0
      end
    end
    context 'page is a lookbook' do
      before do
        page.variables = {:lookbook=>true}
        page.params = {}
      end
      it 'given no variable limit, it return a limit of 20' do
        product_ids = []
        expect(page.limit(product_ids)).to eq 20
      end
      it 'given a variable limit, it returns a limit of the variable' do
        product_ids = []
        page.variables = {:lookbook=>true,:limit=>30}
        expect(page.limit(product_ids)).to eq 30
      end
      it 'given no variable limit, it returns 20, even with product ids' do
        product_ids = ['45', '2']
        expect(page.limit(product_ids)).to eq 20
      end
      it 'given a variable limit, it returns a limit of the variable, even with product ids' do
        product_ids = ['45', '2']
        page.variables = {:lookbook=>true,:limit=>30}
        expect(page.limit(product_ids)).to eq 30
      end
    end
  end

  describe ".offset" do
    let(:product_ids) { (1..product_ids_size).to_a }
    context "given an empty or blank product_ids" do
      let(:product_ids) { nil }
      it { expect(page.offset(product_ids, 0)).to eq 0 }
      it { expect(page.offset(product_ids, 21)).to eq 21 }
      it { expect(page.offset([], 0)).to eq 0 }
      it { expect(page.offset([], 21)).to eq 21 }
    end
    context "given a product_ids.size < 21" do
      let(:product_ids_size) { 11 }
      it { expect(page.offset(product_ids, 0)).to eq 0 }
      it { expect(page.offset(product_ids, 21)).to eq 10 }
      it { expect(page.offset(product_ids, 42)).to eq 31 }
    end
    context "given a product_ids.size == 21" do
      let(:product_ids_size) { 21 }
      it { expect(page.offset(product_ids, 0)).to eq 0 }
      it { expect(page.offset(product_ids, 21)).to eq 0 }
      it { expect(page.offset(product_ids, 42)).to eq 21 }
    end
    context "given a product_ids.size > 21" do
      let(:product_ids_size) { 22 }
      it { expect(page.offset(product_ids, 0)).to eq 0 }
      it { expect(page.offset(product_ids, 21)).to eq 0 }
      it { expect(page.offset(product_ids, 42)).to eq 20 }
    end
  end

  describe ".expand_colours" do
    let(:product_ids) { ["471-coral", "680-light-pink", "683-burgundy", "262-white", "704-black", "504-lavender",
                         "680-forest-green", "371-light-pink", "649-black", "191-burgundy", "539-navy"] }
    it { expect(page.expand_colours(product_ids)).to eq product_ids }
    context 'returns an expanded list' do
      it 'is given a list where the first id does not have a colour' do
        product_ids[0] = '471'
        allow(page).to receive(:insert_colours).and_return(['471-coral', '471-navy', '471-burgundy'])
        expect(page.expand_colours(product_ids).size).to eq 13
      end
      it 'is given a list where the first and third id does not have a colour' do
        product_ids[0] = '471'
        product_ids[2] = '683'
        allow(page).to receive(:insert_colours).and_return(['471-coral', '471-navy', '471-burgundy'], ['683-burgundy', '683-black'])
        expect(page.expand_colours(product_ids).size).to eq 14
      end
      it 'is given a list where the last (eleventh) id does not have a colour' do
        product_ids[10] = '539'
        allow(page).to receive(:insert_colours).and_return(['539-navy', '539-black'])
        expect(page.expand_colours(product_ids).size).to eq 12
      end
    end
  end

  describe '.sort_pids' do
    let(:product_ids) { ["471-coral", "680-light-pink", "683-burgundy", "262-white", "704-black", "504-lavender",
                         "680-forest-green", "371-light-pink", "649-black", "191-burgundy", "539-navy"] }
    it { expect(page.sort_pids(product_ids)).to eq product_ids }
    context 'give a list where the same id is adjacent to each other' do
      it 'has the first and second id the same, but different colours' do
        product_ids[1] = '471-black'
        expect(page.sort_pids(product_ids)[4]).to eq '471-black'
      end
      it 'has the first, second and third id the same, but different colours' do
        product_ids[1] = '471-black'
        product_ids[2] = '471-burgundy'
        p_ids          = page.sort_pids(product_ids)
        expect(page.sort_pids(p_ids)[3]).to eq '471-black'
        expect(page.sort_pids(product_ids)[7]).to eq '471-burgundy'
      end
      it 'has the penultimate and ultimate id the same, but different colours' do
        product_ids[10] = '191-navy'
        expect(page.sort_pids(product_ids)[10]).to eq '191-navy'
      end
      it 'has the antepenultimate and penultimate id the same, but different colours' do
        product_ids[9] = '649-burgundy'
        expect(page.sort_pids(product_ids)[10]).to eq '649-burgundy'
      end
    end

  end
end
