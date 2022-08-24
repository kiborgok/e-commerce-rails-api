require "uri"
require "net/http"
# require "base64"
class OrdersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    skip_before_action :authorize, only: [:index, :create, :show]

    def index
        # orders = Order.all
        # render json: orders, include: user, status: ok
        
        url = URI("https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest")

        https = Net::HTTP.new(url.host, url.port);
        https.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = "application/json"
        request["Authorization"] = "Bearer rKu8LvWo3bmcFsXxsw1rPfzZnhoX"
        body = {
            "BusinessShortCode": 174379,
            "Password": "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMjIwODI0MjM1MDIy",
            "Timestamp": "20220824235022",
            "TransactionType": "CustomerPayBillOnline",
            "Amount": 1,
            "PartyA": 254708374149,
            "PartyB": 174379,
            "PhoneNumber": 254710392014,
            "CallBackURL": "https://mathe-food-api.herokuapp.com/orders",
            "AccountReference": "CompanyXLTD",
            "TransactionDesc": "Payment of X"
        }

        # response = nhttp.start do |http|
            post_data = URI.encode_www_form({xml: body})
            response = https.request(request, post_data)
        # end
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

    def response

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
