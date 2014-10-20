FactoryGirl.define do
  factory :transaction do
    type "Buy"
    bitcoin 12.25
    price_dollar 500.00
    fees_percentage 100
    date "10-08-2013"
  end
end
