require 'rails_helper'

describe Transaction do

  describe 'associations' do
    it do
      should belong_to(:user)
    end
  end
end
