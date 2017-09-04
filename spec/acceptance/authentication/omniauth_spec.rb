require 'acceptance/acceptance_helper'

feature 'Sign in via Twitter & Facebook', %q{
  In order to sign in without typing email & password
  As a user
  I want to be able to sign in with Twitter account
} do
  given(:user) { create(:user) }

  scenario 'User tries to sign in via Facebook' do
    visit new_user_session_path
    mock_auth_hash
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_link 'Sign out'
  end
end