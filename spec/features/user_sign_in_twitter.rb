require 'rails_helper'

feature "User login using twitter" do
  scenario "user can sign in with Twitter account" do
    user = FactoryGirl.create(:user)
    mock_auth_hash_for(user)
    visit root_path

    page.find(".button-custom").click
    expect(page).to have_content("Successfully signed in")
  end
end
