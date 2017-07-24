require 'acceptance/acceptance_helper'

feature 'Sign in', %q{
  In order to ask and answer questions
  As a user
  I want to be able to sign in
} do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Non-registered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@email.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'Signed in user cannot sign in' do
    sign_in(user)
    expect(page).to_not have_link 'Sign in'
  end
end