require 'spec_helper'

describe 'website visit process', :type => :feature do

  let(:user) { create(:spree_user, :skip_welcome_email => true) }

  let!(:revolution_page_dresses) { create(:revolution_page_dresses) }
  let!(:option_type_7) { create(:option_type_7) }
  let!(:option_type_8) { create(:option_type_8) }
  let!(:option_type_11) { create(:option_type_11) }
  let!(:option_values_group_33) { create(:option_values_group_33) }
  let!(:option_values_group_34) { create(:option_values_group_34) }
  let!(:option_values_group_36) { create(:option_values_group_36) }
  let!(:option_values_group_37) { create(:option_values_group_37) }
  let!(:option_values_group_38) { create(:option_values_group_38) }
  let!(:option_values_group_28) { create(:option_values_group_28) }
  let!(:option_values_group_29) { create(:option_values_group_29) }
  let!(:option_values_group_30) { create(:option_values_group_30) }
  let!(:option_values_group_31) { create(:option_values_group_31) }
  let!(:option_values_group_32) { create(:option_values_group_32) }
  let!(:option_values_group_35) { create(:option_values_group_35) }
  let!(:option_value_27) { create(:option_value_27) }

  describe 'login' do

    context 'visit website', :chrome do
      it 'visit website' do
        p 'haha',revolution_page_dresses
        p 'haha1', Revolution::Page.all
        visit '/'
        visit '/dresses'
      end
    end

  end

end
