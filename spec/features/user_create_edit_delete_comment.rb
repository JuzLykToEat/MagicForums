require "rails_helper"

RSpec.feature "User adds new comment and deletes it", type: :feature, js: true do

  scenario "User adds, edits, upvotes, downvotes, and delete comment" do
    visit("http://localhost:3000")

    click_link('Log-in')
    fill_in 'user_email_field', with: 'user3@email.com'
    fill_in 'user_password_field', with: 'user3'
    click_button('Log in')

    expect(find('.flash-messages .message').text).to eql("Welcome back user3")
    expect(find('.nav.navbar-nav.navbar-right')).to have_content("user3")
    expect(page).to have_current_path(root_path)

    click_button('close-button')
    click_link('Topics')
    click_link('Hi Hi Hi')
    click_link("Hi I'm Post 1")

    within('#border-204 .like_dislike_container') { click_on('like-button') }
    expect(find('.flash-messages .message').text).to eql("You've unliked a comment.")
    within('#border-204 .like_dislike_container') { expect(find('.likes-description').text).to eql("1")}
    click_button('close-button')
    within('#border-204 .like_dislike_container') { click_on('dislike-button') }
    expect(find('.flash-messages .message').text).to eql("You've disliked a comment.")
    within('#border-204 .like_dislike_container') { expect(find('.dislikes-description').text).to eql("1")}

    within('#border-204 .like_dislike_container')
  end
end
