class User < ActiveRecord::Base
  has_many :meals
  has_secure_password

  validates :login, presence: true, uniqueness: true, length: {minimum:  3}
  validates :expected_calories, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :password, :length => { :minimum => 6 }, on: :create

  scope :calories_today, -> { includes(:meals).where("meals.ate_at_date = ?", Date.current).references(:meals).sum(:calories)}

  before_create :downcase_login

  def generate_auth_token
    payload = { user_id: self.id }
    AuthTokenEncoder.encode(payload)
  end

  def as_json(options={})
    super(:only => [:login, :name, :expected_calories], :include =>[:meals])
  end

  # to deal with has_secure_password updates
  def self.password_valid?(password)
    return false if password.blank? || password.size < 6
    true
  end

  private

  def downcase_login
    self.login.downcase!
  end
end
