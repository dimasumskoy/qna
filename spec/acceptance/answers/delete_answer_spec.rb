require 'rails_helper'

feature 'Delete answer', %q{
  In order to hide the answer from the question page
  As a user
  I want to be able to delete my own answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authorized user tries to delete his answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to_not have_content answer.body
  end

  scenario 'Authorized user tries to delete NOT his answer' do
    other_user = create(:user)
    sign_in(other_user)

    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Unauthorized user can not delete any answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end
end