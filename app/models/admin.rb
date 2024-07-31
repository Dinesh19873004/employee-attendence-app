class Admin < ApplicationRecord
  has_secure_password
  has_many :employees

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9@._-]{3,80}\z/, message: "invalid_email_format" }
  validates :password, presence: true, format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{5,30}\z/, message: "invalid_password_format" }
end