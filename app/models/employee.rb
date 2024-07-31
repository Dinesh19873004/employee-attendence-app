class Employee < ApplicationRecord
  has_many :attendences
  belongs_to :admin

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9@._-]{3,80}\z/, message: "invalid_email_format" }
  validates :password, presence: true, format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{5,30}\z/, message: "invalid_password_format" }

  has_secure_password

  def monthly_attendance
    attendences
      .where(date: Date.current.beginning_of_month..Date.current.end_of_month)
      .group_by_day(:date)
      .sum(:working_hours)
  end

  # Calculate the sum of working hours for the current year
  def yearly_attendance
    attendences
      .where(date: 1.year.ago.beginning_of_year..Date.current.end_of_year)
      .group_by_month(:date)
      .sum(:working_hours)
  end
end
