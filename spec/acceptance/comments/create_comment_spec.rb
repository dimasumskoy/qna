require 'acceptance/acceptance_helper'

feature 'Create comment', %q{
  In order to comment question or answer
  As a user
  I want to be able to write a comment
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  context 'creating comment' do
    scenario 'Authorized user writes a comment' do
      sign_in(user)
      visit question_path(question)

      click_on 'Write a comment'
      fill_in 'Comment', with: 'Test comment'
      click_on 'Comment this'

      expect(page).to have_content 'Test comment'
    end
    scenario 'Unauthorized user tries to write a comment'
    scenario 'Errors appearance on the comment'
  end
end