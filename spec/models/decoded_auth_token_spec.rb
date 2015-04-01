require 'rails_helper'

describe DecodedAuthToken do
  it { is_expected.to respond_to(:expired?) }

  it 'is expired if current time > exp' do
    subject[:exp] = 10.seconds.ago.to_i
    expect(subject.expired?).to be true
  end

  it 'is not expired if current time < exp' do
    subject[:exp] = 10.seconds.from_now.to_i
    expect(subject.expired?).to be false
  end
end