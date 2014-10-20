require 'rails_helper'

describe User do
  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:url) }
  end

  describe 'associations' do
    it { should have_many(:transactions) }
  end
end
