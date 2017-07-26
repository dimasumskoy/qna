require 'acceptance/acceptance_helper'

feature 'Edit answer', %q{
  In order to fix or amend the text of an answer
  As a user
  I want to be able to edit my answer
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authorized user tries to edit his answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answer_list' do
      expect(page).to have_link 'Edit'

      click_on 'Edit'
      fill_in 'Edit answer', with: 'edited answer'
      click_on 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
    end
  end

  scenario 'Authorized user tries to edit NOT his answer', js: true do
    sign_in(other_user)
    visit question_path(question)

    within '.answer_list' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthorized user tries to edit an answer', js: true do
    visit question_path(question)

    within '.answer_list' do
      expect(page).to_not have_link 'Edit'
    end
  end
end