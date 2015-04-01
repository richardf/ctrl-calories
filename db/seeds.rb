# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

Meal.destroy_all
User.destroy_all

users = User.create([
  {name: 'Mr Foo', login: 'foo', expected_calories: 2000, password: "foobar"},
  {name: 'Luke Skywalker', login: 'luke', expected_calories: 5000, password: "foobar"}
])

Meal.create([
  {user_id: users.first.id, description: 'lots of sashimi', calories: 400, ate_at: DateTime.now},
  {user_id: users.first.id, description: 'nutella', calories: 600, ate_at: 1.hour.ago},
  {user_id: users.first.id, description: 'french fries', calories: 300, ate_at: 1.day.ago},
  {user_id: users.first.id, description: 'salad', calories: 100, ate_at: 2.days.ago}
])

Meal.create([
  {user_id: users.last.id, description: 'The Force', calories: 5000, ate_at: DateTime.now},
])

puts 'Ok!'