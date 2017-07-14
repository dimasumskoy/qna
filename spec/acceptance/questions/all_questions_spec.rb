require 'rails_helper' 
 
feature 'List all questions', %q{ 
  In order to find the question 
  As a user 
  I want to be able to see the list of all questions 
} do 
  scenario 'Any user can see the list of questions' do 
    @questions = create_list(:question, 3) 
 
    visit questions_path 
    expect(page).to have_content @questions[rand(0..3)].title
  end 
end