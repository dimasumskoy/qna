require 'acceptance/acceptance_helper'

feature 'Write an answer to the question', %q{
  In order to help with the question
  As a user
  I want to be able to write an answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  context 'answer creating' do
    scenario 'Authorized user tries to write an answer', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'Answer', with: 'Answer body'
      click_on 'Reply'
      expect(page).to have_content 'Answer body'
    end

    scenario 'Non-authorized user tries to write an answer', js: true do
      visit question_path(question)

      fill_in 'Answer', with: 'Answer body'
      click_on 'Reply'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'Errors appearance for invalid answer', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Reply'
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  context 'answer appearance' do
    scenario 'Answer appears on other\'s user page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Answer', with: 'Answer body'
        click_on 'Reply'
        expect(page).to have_content 'Answer body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Answer body'
      end
    end
  end
end