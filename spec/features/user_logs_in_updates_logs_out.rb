require "rails_helper"

RSpec.feature "User Management", type: :feature, js:true do
  before(:all) do
    @user = create(:user)
  end

  scenario "User logs in, updates & logs out" do

    visit new_session_path
    fill_in 'user_email_field', with: 'user@email.com'
    fill_in 'user_password_field', with: 'password'
    click_button('Log in')

    expect(find('.flash-messages .message').text).to eql("Welcome back bob")
    expect(find('.nav.navbar-nav.navbar-right')).to have_content("bob")
    expect(page).to have_current_path(root_path)

    click_button('close-button')

    click_link('bob')
    fill_in 'user_username_field', with: 'bobby'
    fill_in 'user_email_field', with: 'new_user@email.com'
    click_button('Update')

    expect(find('.flash-messages .message').text).to eql("Details updated.")
    expect(find('.nav.navbar-nav.navbar-right')).to have_content("bobby")

    click_button('close-button')

    click_link('Log-out')

    expect(find('.flash-messages .message').text).to eql("You've been logged out")
    expect(page).to have_current_path(root_path)
  end
end
