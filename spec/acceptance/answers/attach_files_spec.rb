require 'acceptance/acceptance_helper'

feature 'Attach files to question', %q{
  In order to illustrate the answer
  As an answer's author
  I want to be able to attach files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file while answering question', js: true do
    fill_in 'Answer', with: 'test body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Reply'

    within '.answer_list' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_content 'test body'
    end
  end
end