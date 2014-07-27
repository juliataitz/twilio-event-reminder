class AddDeployedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :deployed, :boolean, :default => false
  end
end
