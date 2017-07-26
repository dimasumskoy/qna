require 'acceptance/acceptance_helper'

feature 'Delete question', %q{
  In order to hide the question from the list of all questions
  As a user
  I want to be able to delete my own question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authorized user tries to delete his own question' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_link 'Delete this question'

    click_on 'Delete this question'
    expect(page).to have_content 'Question successfully deleted.'
    expect(page).to have_no_content question.body
  end

  scenario 'Authorized user tries to delete NOT his question' do
    other_user = create(:user)
    sign_in(other_user)

    visit question_path(question)
    expect(page).to_not have_link 'Delete this question'
  end

  scenario 'Unauthorized user can not delete any question' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete this question'
  end
end