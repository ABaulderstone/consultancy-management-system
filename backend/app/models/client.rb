class Client < ApplicationRecord
  has_many :jobs, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
