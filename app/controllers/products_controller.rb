class ProductsController < ApplicationController
    skip_before_action :authorize, only: [:index, :create, :destroy]
    def index
        products = Product.all
        render json: products
    end

    def create
        product = Product.create(product_params)
        if product.valid?
            render json: product, status: :created
        else
            render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        product = Product.find_by(id: params[:id])
        if product
            product.destroy
            head :no_content
        else
            render json: { error: "product not found" }, status: :not_found
        end
    end

    private

    def product_params
        params.permit(:name, :description, :price, :imageSrc)
    end
end
