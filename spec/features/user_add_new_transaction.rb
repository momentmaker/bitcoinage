require 'rails_helper'

feature "Login user can post and see jobs" do
  scenario "login user can post job" do
    user = FactoryGirl.create(:user)
    transaction = FactoryGirl.build(:transaction)
    mock_auth_hash_for(user)
    visit root_path
    page.find(".button-custom").click
    save_and_open_page
    click_on "Add Your First Transaction"
    choose 'Buy'
    fill_in "Bitcoins", with: transaction.bitcoin
    fill_in "Price", with: transaction.price_dollar
    select "1.0%", from: "Fees"
    fill_in "Date", with: transaction.date
    click_on "Create Transaction"
    expect(page).to have_content("Your transaction has be submitted.")
  end

  scenario "user who doesn't login won't be able post job" do
    user = FactoryGirl.create(:user)
    transaction = FactoryGirl.build(:transaction)
    visit new_transaction_path
    expect(page).to have_content("You need to sign in if you want to do that!")
  end
end
