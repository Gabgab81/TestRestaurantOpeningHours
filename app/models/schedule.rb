class Schedule < ApplicationRecord
  belongs_to :restaurant
  # , inverse_of: :schedules, optional: true
  # validates :restaurant, presence: true


  validates :am_opens_at, presence: true
  validates :pm_closes_at, presence: true

  validates :am_closes_at, presence: true, if: -> { pm_opens_at.present? }
  validates :pm_opens_at, presence: true, if: -> { am_closes_at.present? }

  # validates_associated :restaurant
end
