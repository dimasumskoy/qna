require 'acceptance/acceptance_helper'

feature 'Vote for answer', %q{
  In order to agree with the answer
  As an user
  I want to be able to vote for the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user_answer) { create(:answer, question: question, user: user) }

  scenario 'Authorized user votes for the answer', js: true do
    sign_in(user)
    visit question_path(question)

    within "div.answer-#{answer.id}" do
      click_on '+1'
      within '.current_rating' do
        expect(page).to have_content '1'
      end
    end
  end

  scenario 'Authorized user cannot vote twice for the same answer', js: true do
    sign_in(user)
    visit question_path(question)

    within "div.answer-#{answer.id}" do
      click_on '+1'
      click_on '-1'
    end

    expect(page).to have_content 'You cannot vote for this answer'
  end

  scenario 'Authorized user cannot vote for his own answer', js: true do
    sign_in(user)
    visit question_path(question)

    within "div.answer-#{user_answer.id}" do
      expect(page).to_not have_link '+1'
      expect(page).to_not have_link '-1'
    end
  end

  scenario 'Authorized user re-votes the answer', js: true do
    sign_in(user)
    visit question_path(question)

    within "div.answer-#{answer.id}" do
      click_on '+1'

      within '.current_rating' do
        expect(page).to have_content '1'
      end

      click_on 'Revote'
      click_on '-1'

      within '.current_rating' do
        expect(page).to have_content '-1'
      end
    end
  end
end