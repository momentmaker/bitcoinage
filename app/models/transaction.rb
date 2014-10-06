class Transaction < ActiveRecord::Base
  belongs_to :user

  validates :quantity, :price, :date, presence: true
end
