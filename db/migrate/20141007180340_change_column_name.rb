class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :transactions, :quantity, :satoshi
  end
end
