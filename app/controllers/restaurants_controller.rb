class RestaurantsController < ApplicationController
    def index
        render json: {message: "Restaurants controller"}
    end
end
