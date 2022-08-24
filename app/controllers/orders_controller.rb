require "uri"
require "net/http"
# require "base64"
class OrdersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    skip_before_action :authorize, only: [:index, :create, :show]

    def index
        # orders = Order.all
        # render json: orders, include: user, status: ok
        url = URI("https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials")

        https = Net::HTTP.new(url.host, url.port);
        https.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request["Content-Type"] = "application/json"
        request["Authorization"] = "Basic bEdLWnJiUTBxQ2I4V0FCR0hDeUVGU0t6aWs4eDZSNGo6TkpEYkZmOW5wQ29MbnlMUw=="

        response = https.request(request)
        render json: response
    end

    def create
        order = Order.create(order_params)
        if order.valid?
            render json: order, status: :created
        else
            render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    def show
        order = Order.find(params[:id])
        render json: order, include: user
    end

    private
    def order_params
        params.permit(:name, :email, :location, :phone, :amount, :shipping, :user_id)
    end

    def record_not_found
        render json: { error: "Order not found" }, status: :not_found
    end
    
end
