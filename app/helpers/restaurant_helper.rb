module RestaurantHelper
    def invalid?(attribute, day)
        @restaurant.errors.include?(attribute)  && 
        !params[:restaurant].nil? && 
        params[:restaurant][:schedules_attributes][day[:value] == 0 ? "6" : (day[:value] - 1).to_s][:_destroy] == "0"
    end
end