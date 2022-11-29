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

    def whenOpen
        todayOpen = schedules.where(weekday: Time.now.wday)
        if todayOpen.empty?
            day = Time.now.wday + 1
            while schedules.where(weekday: day).empty?
                day == 6 ? day = 0 : day += 1
            end
        else
            amOpen = todayOpen.first.am_opens_at.strftime("%H:%M")
            pmOpen = todayOpen.first.pm_opens_at.nil? ? nil : todayOpen.first.pm_opens_at.strftime("%H:%M")
        end
        time = Time.now.strftime("%H:%M")
        if !todayOpen.empty? && (amOpen > time || (!pmOpen.nil? && pmOpen > time)) 
            if amOpen > time
                openHour = /(\d*):(\d*)/.match(todayOpen.first.am_opens_at.strftime("%H:%M"))
                dopenHour = openHour[1].to_i * 3600 + openHour[2].to_i * 60
                time = /(\d*):(\d*)/.match(time)
                durationTime = time[1].to_i * 3600 + time[2].to_i * 60
                dopenHour - durationTime
            else
                openHour = /(\d*):(\d*)/.match(todayOpen.first.pm_opens_at.strftime("%H:%M"))
                dopenHour = openHour[1].to_i * 3600 + openHour[2].to_i * 60
                time = /(\d*):(\d*)/.match(time)
                durationTime = time[1].to_i * 3600 + time[2].to_i * 60
                dopenHour - durationTime
            end
            # p amOpen, pmOpen, time
        else
            # p Time.now.wday, schedules.where(weekday: Time.zone.now.wday).first.weekday
            day
        end
    end

end
