FactoryGirl.define do
  factory :user do
    sequence(:login)  { |i| "foo#{i}@email.com" }
    sequence(:name)   { |i| "Foo#{i} Bar" }
    expected_calories 2000
    password "foobar"

    trait :with_meals do
		transient do
			meal_count 1
		end
		after(:create) do |user, evaluator|
        	create_list(:meal, evaluator.meal_count, user: user)
        end
    end
  end
end
