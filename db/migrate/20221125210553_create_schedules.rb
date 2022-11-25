class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.time :am_opens_at
      t.time :am_closes_at
      t.time :pm_opens_at
      t.time :pm_closes_at
      t.integer :weekday
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
