require 'acceptance/acceptance_helper'

feature 'Sign up', %q{
  In order to use web-service possibilities
  As a user
  I want to be able to sign up
} do
  given(:user) { create(:user) }

  scenario 'Unregistered user tries to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'new@user.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registered user can not sign up' do
    sign_in(user)
    expect(page).to_not have_link 'Sign up'
  end
end