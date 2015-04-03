class AddAteAtToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :ate_at_date, :date
    change_column :meals, :ate_at_date, :date, null: false
    add_column :meals, :ate_at_time, :time
    change_column :meals, :ate_at_time, :time, null: false
    add_index :meals, :ate_at_date
    add_index :meals, :ate_at_time
  end
end
