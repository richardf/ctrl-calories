class SetCaloriesToNotNull < ActiveRecord::Migration
  def change
    change_column :meals, :calories, :integer, null: false
  end
end
