FactoryGirl.define do
  factory :user do
    sequence(:login)  { |i| "foo#{i}" }
    sequence(:name)   { |i| "Foo#{i} Bar" }
    expected_calories 2000
  end
end
