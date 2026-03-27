class SlugHistory < ApplicationRecord
  belongs_to :user
  scope :active, -> { where("expires_at > ?", Time.current) }

  validates :slug, :expires_at, presence: :true
end
