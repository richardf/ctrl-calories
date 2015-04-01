class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.references :user, index: true
      t.text :description, null: false
      t.integer :calories
      t.datetime :ate_at, null: false

      t.timestamps null: false
    end
    add_foreign_key :meals, :users
  end
end
