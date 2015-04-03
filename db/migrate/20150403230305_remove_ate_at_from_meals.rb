class RemoveAteAtFromMeals < ActiveRecord::Migration
  def change
  	remove_column :meals, :ate_at
  end
end
