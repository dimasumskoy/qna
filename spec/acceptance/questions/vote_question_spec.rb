require 'acceptance/acceptance_helper'

feature 'Vote for question', %q{
  In order to agree with the question
  As an user
  I want to be able to vote for the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }

  scenario 'Authorized user votes for the question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on '+1'
      within '.rating' do
        expect(page).to have_content '1'
      end
    end
  end

  scenario 'Authorized user cannot vote twice for the same question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on '+1'
      click_on '-1'

      within '.rating' do
        expect(page).to have_content 'You cannot vote for this question'
      end
    end
  end

  scenario 'Authorized user cannot vote for his own question', js: true do
    sign_in(user)
    visit question_path(user_question)

    within '.question' do
      expect(page).to_not have_link '+1'
      expect(page).to_not have_link '-1'
    end
  end

  scenario 'Authorized user re-votes the question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on '+1'

      within '.rating' do
        expect(page).to have_content '1'
      end

      click_on 'Revote'
      click_on '-1'

      within '.rating' do
        expect(page).to have_content '-1'
      end
    end
  end
end