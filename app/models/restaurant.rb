class Restaurant < ApplicationRecord
    has_many :schedules, dependent: :destroy
    # , inverse_of: :restaurant
    accepts_nested_attributes_for :schedules, allow_destroy: true

    validates :schedules, presence: true
    validates :name, presence: true

    def open?
        isOpen = false
        time = Time.now
        time = time.in_time_zone('Eastern Time (US & Canada)').strftime("%H:%M")
        schedule = schedules.where(weekday: Time.zone.now.wday).first
        if !schedule.nil?
            # time > todayOpen.pm_closes_at.strftime("%H:%M")  
            if (schedule.am_closes_at.nil? && 
                time > schedule.am_opens_at.strftime("%H:%M") && 
                time < schedule.pm_closes_at.strftime("%H:%M")) || 
                (!schedule.am_closes_at.nil? && 
                ((time > schedule.am_opens_at.strftime("%H:%M") && time < schedule.am_closes_at.strftime("%H:%M")) || 
                (time > schedule.pm_opens_at.strftime("%H:%M") && time < schedule.pm_closes_at.strftime("%H:%M"))))
                p 'if1'
                isOpen =  true 
            end
        else
            p 'elseé'
            isOpen    
        end
    end

end
