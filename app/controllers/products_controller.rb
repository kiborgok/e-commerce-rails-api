class ProductsController < ApplicationController
    skip_before_action :authorize, only: [:index, :create]
    def index
        restaurants = Restaurant.all
        render json: restaurants
    end

    def create
        restaurant = Restaurant.create(restaurant_params)
        if restaurant.valid?
            render json: restaurant, status: :created
        else
            render json: { errors: restaurant.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def restaurant_params
        params.permit(:name, :location, :imageSrc)
    end
end
