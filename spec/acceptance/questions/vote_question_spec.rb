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

    within 'div.question' do
      click_on '+1'
      within 'div.question-votes' do
        expect(page).to have_content 'Rating: 1'
      end
    end
  end

  scenario 'Authorized user cannot vote twice for the same question' do
    sign_in(user)
    visit question_path(question)

    within 'div.question' do
      click_on '+1'
      click_on '-1'
    end

    expect(page).to have_content 'You cannot vote twice for this question'
  end

  scenario 'Authorized user cannot vote for his own question' do
    sign_in(user)
    visit question_path(user_question)

    within 'div.question' do
      expect(page).to_not have_link '+1'
      expect(page).to_not have_link '-1'
    end
  end

  scenario 'Authorized user re-votes the question' do
    sign_in(user)
    visit question_path(question)

    within 'div.question' do
      click_on '+1'
      within 'div.question-votes' do
        expect(page).to have_content 'Rating: 1'
      end
    end

    within 'div.question' do
      click_on 'Revote'
      click_on '-1'
      within 'div.question-votes' do
        expect(page).to have_content 'Rating: -1'
      end
    end
  end
end