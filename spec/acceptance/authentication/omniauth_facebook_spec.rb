require 'acceptance/acceptance_helper'

feature 'Sign in via Facebook', %q{
  In order to sign in without typing email & password
  As a user
  I want to be able to sign in with Facebook account
} do
  given!(:user) { create(:user) }

  background do
    facebook_mock_auth_hash
  end

  scenario 'User tries to sign up with facebook' do
    visit new_user_session_path
    click_on 'Sign in with Facebook'

    open_email('test@qna.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'User tries to sign in with Facebook' do
    user.confirm
    user.authorizations.create(provider: facebook_mock_auth_hash.provider, uid: facebook_mock_auth_hash.uid)

    visit new_user_session_path
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from facebook account.'
  end
end