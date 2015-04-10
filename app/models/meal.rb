class Meal < ActiveRecord::Base
	include Filterable

	belongs_to :user

	validates :description, presence: true
	validates :calories, numericality: { only_integer: true, greater_than: 0 }, allow_nil: false
	validates :user, presence: true
	validates :ate_at_date, presence: true
	validates :ate_at_time, presence: true

	scope :start_date,	-> (date) {where("ate_at_date >= ?", date)}
	scope :end_date,	-> (date) {where("ate_at_date <= ?", date)}
	scope :start_time,	-> (time) {where("strftime('%H:%M', ate_at_time) >= ?", time)}
	scope :end_time,	-> (time) {where("strftime('%H:%M', ate_at_time) <= ?", time)}

	def as_json(options={})
		data = super(only: [:id, :description, :calories, :ate_at_date, :ate_at_time])
		data['ate_at_time'] = ate_at_time.strftime('%H:%M') if data.key? 'ate_at_time'
		data['ate_at_date'] = ate_at_date.strftime('%Y-%m-%d') if data.key? 'ate_at_date'
		data
	end
end
