require 'rails_helper'

feature 'Create question', %q{
  In order to get an answer
  As a user
  I want to be able to ask a question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authorized user tries to create a question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Create'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Unauthorized user tries to create a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Errors appearance for invalid question' do
    sign_in(user)
    visit new_question_path

    click_on 'Create'
    save_and_open_page
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end
end