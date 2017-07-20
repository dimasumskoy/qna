require 'rails_helper'

feature 'Edit question', %q{
  In order to amend the question
  As a user
  I want to be able to edit my question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authorized user tries to edit his question'
  scenario 'Authorized user tries to edit someone else question'
  scenario 'Unauthorized user tries to edit the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end