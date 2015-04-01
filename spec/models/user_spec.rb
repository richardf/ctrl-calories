require 'rails_helper'

RSpec.describe User, type: :model do
  subject {build(:user)}
  it { is_expected.to respond_to(:login) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:expected_calories) }
  it { is_expected.to respond_to(:meals) }

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

  it 'is valid without expected calories' do
    subject.expected_calories = nil
    expect(subject.valid?).to be true
  end

  it 'does not allow duplicated login names' do
    user = create(:user)
    expect {create(:user, login: user.login)}.to raise_error(ActiveRecord::RecordInvalid)
  end
end
