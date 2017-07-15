require 'rails_helper'

feature 'Write an answer to the question', %q{
  In order to help with the question
  As a user
  I want to be able to write an answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authorized user tries to write an answer' do
    sign_in(user)
    check_question_body(question)

    fill_in 'Body', with: answer.body
    click_on 'Reply'
    expect(page).to have_content answer.body
  end

  scenario 'Non-authorized user tries to write an answer' do
    check_question_body(question)
    
    fill_in 'Body', with: 'Answer body'
    click_on 'Reply'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end