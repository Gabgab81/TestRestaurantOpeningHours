class RestaurantsController < ApplicationController


    def index
        @restaurants = Restaurant.all
        # raise
    end

    def show
        @restaurant = Restaurant.find(params[:id])
    end

    def new
        @restaurant = Restaurant.new
    end

    def create
        @restaurant = Restaurant.new(restaurant_params)
        @restaurant.save
        redirect_to restaurant_path(@restaurant)
    end

    def destroy
        
    end

    private

    def restaurant_params
        params.require(:restaurant).permit(:name)
    end

end
