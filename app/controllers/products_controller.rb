class ProductsController < ApplicationController
    def index
        render json: {message: "Products controller"}
    end
end
