require 'rails_helper' 
 
feature 'List all questions', %q{ 
  In order to find the question 
  As a user 
  I want to be able to see the list of all questions 
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'Any user can see the list of questions' do 
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end 
end