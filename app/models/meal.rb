class Meal < ActiveRecord::Base
	include Filterable

	belongs_to :user

	validates :description, presence: true
	validates :calories, numericality: { only_integer: true, greater_than: 0 }, allow_nil: false
	validates :user, presence: true
	validates :ate_at_date, presence: true
	validates :ate_at_time, presence: true

	def as_json(options={})
		super(:only => [:id, :description, :calories, :ate_at_date, :ate_at_time])
	end
end
