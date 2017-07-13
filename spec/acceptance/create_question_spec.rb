require 'rails_helper'

feature 'Create question', %q{
  In order to get an answer
  As a user
  I want to be able to ask a question
} do
  scenario 'Authorized user creates a question' do
    User.create!(email: 'user@test.com', password: '12345')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345'
    click_on 'Log in'

    visit questions_path
    click_on 'Create question'
    fill_in 'Title', with: 'title'
    fill_in 'Body', with: 'text'
    click_ion 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end
end