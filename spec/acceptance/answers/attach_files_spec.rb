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

    fill_in 'Answer', with: 'test body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'User adds files while answering question', js: true do
    click_on 'Add more files'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Reply'

    within '.answer_list' do
      expect(page).to have_content 'test body'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end

  scenario 'User deletes attached files from his answer', js: true do
    click_on 'Reply'

    within '.answer_list' do
      click_on 'Delete attachment'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end
end