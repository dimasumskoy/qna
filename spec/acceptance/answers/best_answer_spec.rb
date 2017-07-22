require 'rails_helper'

feature 'Best answer', %q{
  In order to choose the the most helpful answer
  As an author of the question
  I want to be able to mark the answer as the best answer
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: other_user) }

  scenario 'Author of the question tries to mark the answer as best' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content answer.body
    within ".answer-#{answer.id}" do
      click_on 'Best answer'
      expect(page).to have_selector '.best-answer'
    end
  end
  scenario 'Other authorized user tries to mark the answer as best'
  scenario 'Unauthorized user tries to mark the answer as best'
end