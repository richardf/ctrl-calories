# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

Meal.destroy_all
User.destroy_all

users = User.create([
  {name: 'Foo Bar', login: 'foo@bar.com', expected_calories: 2000, password: "foobar"},
  {name: 'Luke Skywalker', login: 'luke@sw.com', expected_calories: 5000, password: "foobar"}
])

Meal.create([
  {user_id: users.first.id, description: 'lots of sashimi', calories: 400, ate_at_time: Time.current, ate_at_date: Date.current},
  {user_id: users.first.id, description: 'nutella', calories: 600, ate_at_time: 1.hour.ago, ate_at_date: Date.current},
  {user_id: users.first.id, description: 'french fries', calories: 300, ate_at_time: 15.minutes.ago, ate_at_date: 1.day.ago},
  {user_id: users.first.id, description: 'salad', calories: 100, ate_at_time: 120.minutes.ago, ate_at_date: 2.days.ago},
  {user_id: users.first.id, description: 'tomato soup', calories: 150, ate_at_time: 5.hour.ago, ate_at_date: 3.days.ago},
  {user_id: users.first.id, description: 'bread', calories: 250, ate_at_time: 145.minutes.ago, ate_at_date: 3.days.ago}
])

Meal.create([
  {user_id: users.last.id, description: 'The Force', calories: 5000, ate_at_time: Time.current, ate_at_date: Date.current},
])

puts 'Ok!'