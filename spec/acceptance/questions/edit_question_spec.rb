require 'rails_helper'

feature 'Edit question', %q{
  In order to amend the question
  As a user
  I want to be able to edit my question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authorized user tries to edit his question', js: true do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_link 'Edit'

    click_on 'Edit'

    within '.question' do
      fill_in 'Title', with: 'Edited title'
      fill_in 'Body', with: 'Edited body'
      click_on 'Save'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body

      expect(page).to have_content 'Edited title'
      expect(page).to have_content 'Edited body'
    end
  end
  scenario 'Authorized user tries to edit someone else question'
  scenario 'Unauthorized user tries to edit the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end