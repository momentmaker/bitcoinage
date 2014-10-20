require 'spec_helper'
feature 'Sign in via Twitter' do
  let!(:user) { create(:user, :with_twitter_account) }
  background do
    visit root_path
    click_link 'Sign in'
  OmniAuth.config.mock_auth[:twitter] = {
    provider: 'twitter',
    uid: user.twitter_account.uid,
    credentials: {
      token: 'twitter token'
    }
  }
  end
  scenario 'click login via twitter' do
    click_link 'Login via Twitter'
    page.should display_flash_message('Signed in successfully.')
  end
end
