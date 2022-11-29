class RestaurantsController < ApplicationController


    def index
        @restaurants = Restaurant.all
        # raise
    end

    def show
        @restaurant = Restaurant.find(params[:id])
        # raise
    end

    def new
        @restaurant = Restaurant.new
    end

    def create
        @restaurant = Restaurant.new(restaurant_params)
        # raise
        if @restaurant.save
            # raise
            redirect_to restaurant_path(@restaurant)
        else
            # raise
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @restaurant = Restaurant.find(params[:id])
    end

    def update
        @restaurant = Restaurant.find(params[:id])
        if @restaurant.update(restaurant_params)
            # raise
            redirect_to restaurant_path(@restaurant)
        else
            # raise
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @restaurant = Restaurant.find(params[:id])
        # raise
        @restaurant.destroy
        redirect_to restaurants_path, status: :see_other
    end

    private

    def restaurant_params
        params.require(:restaurant).permit(:name, schedules_attributes:[
            :id,
            :am_opens_at,
            :am_closes_at,
            :pm_opens_at,
            :pm_closes_at,
            :weekday,
            :_destroy
        ])
    end

end
