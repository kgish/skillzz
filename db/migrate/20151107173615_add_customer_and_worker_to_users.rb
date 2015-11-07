class AddCustomerAndWorkerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :customer, :boolean, default: false
    add_column :users, :worker, :boolean, default: false
  end
end
