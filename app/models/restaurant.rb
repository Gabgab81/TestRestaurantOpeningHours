class Restaurant < ApplicationRecord
    has_many :schedules, dependent: :destroy
    accepts_nested_attributes_for :schedules, allow_destroy: true
end
