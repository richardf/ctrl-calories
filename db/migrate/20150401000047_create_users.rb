class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :login, null: false
      t.integer :expected_calories

      t.timestamps null: false
    end
    add_index :users, :login
  end
end
