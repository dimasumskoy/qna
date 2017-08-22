require 'acceptance/acceptance_helper'

feature 'Create question', %q{
  In order to get an answer
  As a user
  I want to be able to ask a question
} do
  given(:user) { create(:user) }

  context 'question creating' do
    scenario 'Authorized user tries to create a question' do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Test title'
      fill_in 'Body', with: 'Test body'
      click_on 'Create'

      expect(page).to have_content 'Test title'
      expect(page).to have_content 'Test body'
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
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'question appearance' do
    scenario 'Question appears on other\'s user page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test title'
        fill_in 'Body', with: 'Test body'
        click_on 'Create'

        expect(page).to have_content 'Test title'
        expect(page).to have_content 'Test body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test title'
      end
    end
  end
end