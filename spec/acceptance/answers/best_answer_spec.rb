require 'acceptance/acceptance_helper'

feature 'Best answer', %q{
  In order to choose the the most helpful answer
  As an author of the question
  I want to be able to mark the answer as the best answer
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: other_user) }
  given(:answer_list) { create_list(:answer, 3, question: question, user: other_user) }

  scenario 'Author of the question tries to mark the answer as best', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content answer.body
    within ".answer-#{answer.id}" do
      click_on 'Best answer'
      expect(page).to have_selector '.best-answer'
    end
  end

  scenario 'Other authorized user tries to mark the answer as best', js: true do
    sign_in(other_user)
    visit question_path(question)

    within ".answer_list" do
      expect(page).to_not have_link 'Best answer'
    end
  end

  scenario 'Unauthorized user tries to mark the answer as best', js: true do
    visit question_path(question)
    within ".answer_list" do
      expect(page).to_not have_link 'Best answer'
    end
  end
end