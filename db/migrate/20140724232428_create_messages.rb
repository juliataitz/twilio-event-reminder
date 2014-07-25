class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.text :content
      t.datetime :posted_time

      t.timestamps
    end
  end
end
