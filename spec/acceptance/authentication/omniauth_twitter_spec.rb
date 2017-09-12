require 'acceptance/acceptance_helper'

feature 'Sign in via Twitter', %q{
  In order to sign in without typing email & password
  As a user
  I want to be able to sign in with Twitter account
} do
  given!(:user) { create(:user) }

  scenario 'User tries to sign up with twitter' do
    twitter_mock_auth_hash
    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Please enter your email before continuing'

    fill_in 'Email', with: 'test@qna.com'
    click_on 'Send'

    open_email('test@qna.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'User tries to sign in with twitter' do
    user.confirm
    user.authorizations.create(provider: twitter_mock_auth_hash.provider, uid: twitter_mock_auth_hash.uid)

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from twitter account.'
  end
end