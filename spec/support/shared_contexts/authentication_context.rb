shared_context 'authenticated_user' do

  let(:user) { create(:spree_user, :skip_welcome_email => true) }
  
  before do 
    visit '/us/login'
    within('#password-credentials') do
      fill_in 'Email', :with => user.email
      fill_in 'Password', :with => user.password
    end
    click_button 'Log-in'        
    expect(page).to_not have_content 'Invalid email or password.'        
    expect(page).to have_content 'sign out'
    expect(page).to have_content user.full_name
  end

end
