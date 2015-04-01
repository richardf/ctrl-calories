require 'rails_helper'

RSpec.describe Meal, type: :model do
  subject {build(:meal_with_user)}

  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:calories) }
  it { is_expected.to respond_to(:ate_at) }

  context 'is invalid' do
    it 'without a description' do
      subject.description = ''
      expect(subject.valid?).to be false
    end

    it 'without calories' do
      subject.calories = nil
      expect(subject.valid?).to be false
    end

    it 'without a user' do
      subject.user = nil
      expect(subject.valid?).to be false
    end

    it 'without eaten time' do
      subject.ate_at = nil
      expect(subject.valid?).to be false
    end

    it 'with non-numerical calories' do
      subject.calories = 'a'
      subject.valid?
      expect(subject.errors).to include(:calories)
    end

    it 'with zero calories' do
      subject.calories = 0
      subject.valid?
      expect(subject.errors).to include(:calories)
    end

    it 'with negative values for calories' do
      subject.calories = -1
      subject.valid?
      expect(subject.errors).to include(:calories)
    end
  end

  it 'is valid when filled properly' do
    expect(subject.valid?).to be true
  end
end
