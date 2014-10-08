class ChangeColumnNames < ActiveRecord::Migration
  def change
    rename_column :transactions, :price, :price_cent
    rename_column :transactions, :fees, :fees_percentage
  end
end
