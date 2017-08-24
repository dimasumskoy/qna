require 'acceptance/acceptance_helper'

feature 'Create comment', %q{
  In order to comment question or answer
  As a user
  I want to be able to write a comment
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  context 'comment creating' do
    scenario 'Authorized user writes a comment', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'Comment', with: 'Test comment'
      click_on 'Comment this'

      within '.comments' do
        expect(page).to have_content 'Test comment'
      end
    end

    scenario 'Unauthorized user tries to write a comment', js: true do
      visit question_path(question)

      fill_in 'Comment', with: 'Test comment'
      click_on 'Comment this'

      expect(page).to_not have_content 'Test comment'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'Errors appearance on the comment', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'Comment', with: ''
      click_on 'Comment this'

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  context 'comment appearance' do
    scenario 'Comment appears on other\'s user page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Comment', with: 'Comment body'
        click_on 'Comment this'
        expect(page).to have_content 'Comment body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment body'
      end
    end
  end
end