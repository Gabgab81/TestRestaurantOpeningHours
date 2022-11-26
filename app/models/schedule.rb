class Schedule < ApplicationRecord
  belongs_to :restaurant

  validates :am_opens_at, presence: true
  validates :pm_closes_at, presence: true
end
