require 'rails_helper'

describe DecodedAuthToken do
  it { is_expected.to respond_to(:expired?) }
end