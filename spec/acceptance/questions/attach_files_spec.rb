require 'acceptance/acceptance_helper'

feature 'Attach files to question', %q{
  In order to illustrate the question
  As an question's author
  I want to be able to attach files
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'test title'
    fill_in 'Body', with: 'test body'

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'User adds file while asking question', js: true do
    click_on 'Add more files'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create'

    expect(page).to have_content 'test title'
    expect(page).to have_content 'test body'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

  scenario 'User deletes attached files from his question', js: true do
    click_on 'Create'

    within '.question' do
      click_on 'Delete attachment'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end
end