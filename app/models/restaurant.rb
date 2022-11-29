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
                isOpen =  true 
            end
        else
            isOpen    
        end
    end

    def whenClose
        if self.open?
            schedule = schedules.where(weekday: Time.now.wday).first
            time = Time.now.strftime("%H:%M")
            timeMached = /(\d*):(\d*)/.match(time)
            durationTime = timeMached[1].to_i * 3600 + timeMached[2].to_i * 60
            if !schedule.am_closes_at.nil? && time < schedule.am_closes_at.strftime("%H:%M")
                hourSecond(schedule.am_closes_at.strftime("%H:%M")) - durationTime
            else
                hourSecond(schedule.pm_closes_at.strftime("%H:%M")) - durationTime
            end
        else
            0
        end
    end

    def whenOpen
        if !self.open?
            todayOpen = schedules.where(weekday: Time.now.wday)
            time = Time.now.strftime("%H:%M")
            if !todayOpen.empty?
                amOpen = todayOpen.first.am_opens_at.strftime("%H:%M")
                pmOpen = todayOpen.first.pm_opens_at.nil? ? nil : todayOpen.first.pm_opens_at.strftime("%H:%M")
                pmClose = todayOpen.first.pm_closes_at.strftime("%H:%M")
                if pmClose < time
                    nday, day, amOpen = ndayDayAmopen
                end
            else
                nday, day, amOpen = ndayDayAmopen
            end
            timeMached = /(\d*):(\d*)/.match(time)
            durationTime = timeMached[1].to_i * 3600 + timeMached[2].to_i * 60
            if !todayOpen.empty? && (amOpen > time || (!pmOpen.nil? && pmOpen > time)) 
                if amOpen > time
                    hourSecond(amOpen) - durationTime
                else
                    hourSecond(amOpen) - durationTime
                end
            else
                nday * 3600 * 24 - durationTime + hourSecond(amOpen)
            end
        else
            0
        end
    end

    private

    def hourSecond(h)
        openHour = /(\d*):(\d*)/.match(h)
        dopenHour = openHour[1].to_i * 3600 + openHour[2].to_i * 60
    end

    def ndayDayAmopen
        nday = 1
        day = Time.now.wday + 1
        while schedules.where(weekday: day).empty? && Time.now.wday != day
            nday += 1
            day == 6 ? day = 0 : day += 1
        end
        amOpen = schedules.where(weekday: day).first.am_opens_at.strftime("%H:%M")
        return nday, day, amOpen
    end

end
