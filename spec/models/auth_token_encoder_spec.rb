require 'rails_helper'

describe AuthTokenEncoder do
  subject {AuthTokenEncoder}

  it { is_expected.to respond_to(:encode) }
  it { is_expected.to respond_to(:decode) }

  it 'encode must return JWT token' do
    expect(subject.encode({foo: 'bar'})).to be_kind_of String
  end

  it 'decode must return nil if invalid token is given' do
    expect(subject.decode("invalid")).to be nil
  end

  it 'decode must return AuthToken if valid token is given' do
    token = subject.encode({foo: "bar"})
    decoded = subject.decode(token)
    expect(decoded).to be_kind_of DecodedAuthToken
    expect(decoded[:foo]).to eq("bar")
  end
end