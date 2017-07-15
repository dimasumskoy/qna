require 'rails_helper'

feature 'Delete question', %q{
  In order to hide the question from the list of all questions
  As a user
  I want to be able to delete the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user) }

  scenario 'Authorized user tries to delete his own question' do
    sign_in(user)
    visit question_path(user)
    expect(page).to have_link 'Delete this question'
  end
end