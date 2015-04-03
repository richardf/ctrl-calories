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

  context 'meal as json' do
    let(:json) {build(:meal).as_json}
    it 'should include id, description, calories and ate_at' do
      expect(json).to include('id')
      expect(json).to include('description')
      expect(json).to include('calories')
      expect(json).to include('ate_at')
    end

    it 'should not include user_id, created_at and updated_at' do
      expect(json).not_to include('user_id')
      expect(json).not_to include('created_at')
      expect(json).not_to include('updated_at')
    end
  end  
end
