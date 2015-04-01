class User < ActiveRecord::Base
  has_many :meals
  has_secure_password

  validates :login, presence: true, uniqueness: true, length: {minimum:  3}
  validates :expected_calories, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :password, :length => { :minimum => 5 }
  validates_confirmation_of :password

  def generate_auth_token
    payload = { user_id: self.id }
    AuthTokenEncoder.encode(payload)
  end
end
