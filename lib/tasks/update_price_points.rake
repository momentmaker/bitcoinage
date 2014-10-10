namespace :bitcoin do
  task update_prices: :environment do
    PricePoint.update_prices
  end
end
