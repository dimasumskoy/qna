require 'acceptance/acceptance_helper'

feature 'Subscribe to question', %q{
  In order to receive notifications about new answers
  As a user
  I want to be able to subscribe to question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authorized user tries to subscribe to question' do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end
  end

  scenario 'Unauthorized user tries to subscribe' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Subscribe'
    end
  end
end