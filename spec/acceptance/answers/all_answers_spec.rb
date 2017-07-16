require 'rails_helper'

feature 'List all question answers', %q{
  In order to find the right answer to the question
  As a user
  I want to see all the answers to the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Any user can see the list of answers to the question' do
    visit question_path(question)

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end