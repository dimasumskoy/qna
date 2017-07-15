module AcceptanceMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def check_question_body(question)
    visit question_path(question)
    expect(page).to have_content question.body
  end

  def check_without_deleting_answer(question)
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end

  def check_without_deleting(question)
    visit question_path(question)
    expect(page).to_not have_link 'Delete this question'
  end
end