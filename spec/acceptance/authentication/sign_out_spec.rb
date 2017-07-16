require 'rails_helper'

feature 'Sign out', %q{
  In order to complete the session
  As a user
  I want to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Authorized user tries to sign out' do
    sign_in(user)
    expect(page).to have_link 'Sign out'

    click_link 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthorized user can not sign out' do
    expect(page).to_not have_link 'Sign out'
  end
end