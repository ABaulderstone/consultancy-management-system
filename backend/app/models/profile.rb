class Profile < ApplicationRecord
  belongs_to :user
  validates :first_name, :last_name, presence: true
  validate :date_of_birth_format

  enum :gender, { male: 0, female: 1, other: 2, prefer_not_to_say: 3 }

  def age
    return unless date_of_birth

    now = Date.today
    age = now.year - date_of_birth.year
    age -= 1 if Date.new(now.year, date_of_birth.month, date_of_birth.day) > now
    age
  end



  private

    def date_of_birth_format
      return if date_of_birth.blank?
      Date.parse(date_of_birth.to_s)
    rescue ArgumentError
      errors.add(:date_of_birth, "is invalid")
    end
end
