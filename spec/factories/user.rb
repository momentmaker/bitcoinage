FactoryGirl.define do
  factory :user do
    provider "twitter"
    uid "1234"
    name "Bit Coin"
    username "bitcoinage"
    url "http://placebear.com/200/300"
  end
end
