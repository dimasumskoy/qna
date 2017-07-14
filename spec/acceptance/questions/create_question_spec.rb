require 'rails_helper'

feature 'Create question', %q{
  In order to get an answer
  As a user
  I want to be able to ask a question
} do
  scenario 'Authorized user creates a question' do
    User.create!(email: 'user@test.com', password: '123456')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'title'
    fill_in 'Body', with: 'text'
    click_on 'Create'

    expect(page).to have_content 'title'
  end

  scenario 'Unauthorized user tries to create a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end