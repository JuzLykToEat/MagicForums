require "rails_helper"

RSpec.feature "User Management", type: :feature, js:true do
  before(:all) do
    @user = create(:user)
  end

  scenario "User logs in" do

    visit new_user_path
    fill_in 'user_username_field', with: 'ironman'
    fill_in 'user_email_field', with: 'ironman@email.com'
    fill_in 'user_password_field', with: 'password'

    click_button('Register')

    user = User.find_by(email: "ironman@email.com")

    expect(User.count).to eql(2)
    expect(user).to be_present
    expect(user.email).to eql("ironman@email.com")
    expect(user.username).to eql("ironman")
    expect(find('.flash-messages .message').text).to eql("You've registered.")
    expect(page).to have_current_path(root_path)
  end
end
