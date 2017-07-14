require 'rails_helper'

feature 'Write an answer to the question', %q{
  In order to help with the question
  As a user
  I want to be able to write an answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { question.answers.new(attributes_for(:answer)).save }

  scenario 'An authorized user tries to write an answer' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    
    visit question_path(question)
    expect(page).to have_content question.body

    fill_in 'Body', with: 'Test answer'
    click_on 'Reply'
    expect(page).to have_content 'Test answer'
  end
end