require 'acceptance/acceptance_helper'

feature 'Search', %q{
  In order to find some text
  As a user
  I want to be able to use search
} do
  given!(:questions) { create_list(:question, 3) }
  given!(:answers)   { create_list(:answer, 3) }
  given!(:comments)  { create_list(:comment, 3) }
  given!(:users)     { create_list(:user, 3) }
  given(:all) { [questions, answers, comments].flatten! }

  background do
    index
    visit root_path
  end

  scenario 'User tries to find text in questions', js: true do
    select('Questions', from: :scope)
    fill_in :search, with: "question\n"

    questions.each do |question|
      expect(page).to have_link question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'User tries to find text in answers', js: true do
    select('Answers', from: :scope)
    fill_in :search, with: "answer\n"

    answers.each do |answer|
      expect(page).to have_link answer.question.title
      expect(page).to have_content answer.body
    end
  end

  scenario 'User tries to find text in comments', js: true do
    select('Comments', from: :scope)
    fill_in :search, with: "comment\n"

    comments.each do |comment|
      expect(page).to have_content comment.body
    end
  end

  scenario 'User tries to find text in users', js: true do
    select('Users', from: :scope)
    fill_in :search, with: "test\n"

    users.each do |user|
      expect(page).to have_content user.email
    end
  end

  scenario 'User tries to find text in All scopes', js: true do
    select('All', from: :scope)
    fill_in :search, with: "for\n"

    all.each do |result|
      expect(page).to have_content result.body
    end
  end
end