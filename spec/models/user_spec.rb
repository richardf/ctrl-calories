require 'rails_helper'

RSpec.describe User, type: :model do
  subject {build(:user)}
  it { is_expected.to respond_to(:login) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:expected_calories) }
  it { is_expected.to respond_to(:meals) }
  it { is_expected.to respond_to(:generate_auth_token) }

  context 'is invalid' do
    it 'without a login' do
      subject.login = nil
      expect(subject.valid?).to be false
    end

    it 'with less than 3 characters' do
      subject.login = 'fo'
      subject.valid?
      expect(subject.errors).to include(:login)
    end

    it 'with non-numerical calories' do
      subject.expected_calories = 'a'
      subject.valid?
      expect(subject.errors).to include(:expected_calories)
    end

    it 'with zero calories' do
      subject.expected_calories = 0
      subject.valid?
      expect(subject.errors).to include(:expected_calories)
    end

    it 'with negative values for calories' do
      subject.expected_calories = -1
      subject.valid?
      expect(subject.errors).to include(:expected_calories)
    end
  end

  context 'when creating' do
    it 'fails if no password' do
      subject.password = nil
      expect(subject.save).to be false
    end

    it 'fails if password length < 6' do
      subject.password = 'abcd'
      expect(subject.save).to be false
    end

    it 'succeeds if password is ok' do
      expect(subject.save).to be true
    end

    it 'fails because password confirmation doesnt match' do
      subject.password_confirmation = 'totally different pass'
      expect(subject.save).to be false
    end

    it 'succeeds because password confirmation match' do
      subject.password_confirmation = subject.password
      expect(subject.save).to be true
    end

    it 'should save login as lowercase' do
      subject.login = 'UPCASE_LOGIN'
      subject.save
      expect(User.last.login).to eq('upcase_login')
    end
  end

  it 'is valid without expected calories' do
    subject.expected_calories = nil
    expect(subject.valid?).to be true
  end

  it 'does not allow duplicated login names' do
    user = create(:user)
    expect {create(:user, login: user.login)}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'generates auth token' do
    expect(subject.generate_auth_token).to be_kind_of String
    expect(subject.generate_auth_token.size).to be > 10
  end

  context 'validate password' do
    it 'is true with valid password' do
      expect(User.password_valid?('good_password', 'good_password')).to be true
    end

    it 'is false with short password' do
      expect(User.password_valid?('short', 'short')).to be false
    end

    it 'is false with password and confirmation different' do
      expect(User.password_valid?('password123', '123password')).to be false
    end
  end

  it 'calories_today should give the number of calories consumed in present day' do
    user = create(:user, :with_meals, meal_count: 3)
    sum = 0
    user.meals.each {|m| sum += m.calories}
    Meal.create(user: user, description: 'lunch', calories: 400, ate_at_date: 1.day.ago, ate_at_time: 1.day.ago)
    expect(User.where(id: user.id).calories_today).to eq(sum)
  end


  context 'user as json' do
    let(:json) {build(:user).as_json}
    it 'should include name, login, expected_calories and meals' do
      expect(json).to include("login")
      expect(json).to include("name")
      expect(json).to include("expected_calories")
      expect(json).to include("meals")
    end

    it 'should not include id, created_at, updated_at and password_digest' do
      expect(json).not_to include("id")
      expect(json).not_to include("created_at")
      expect(json).not_to include("updated_at")
      expect(json).not_to include("password_digest")
    end
  end
end
