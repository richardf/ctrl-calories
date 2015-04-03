FactoryGirl.define do
  factory :meal do
    description 'lots of sashimi'
    sequence(:calories)  { |i| i*100 }
    ate_at_time Time.current
    ate_at_date Date.current

    factory :meal_with_user do
      association :user, strategy: :build
    end
  end
end