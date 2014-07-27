class AddSignupsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :signups, :integer
  end
end
