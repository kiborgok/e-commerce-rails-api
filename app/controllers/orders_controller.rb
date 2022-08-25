require "uri"
require "net/http"
require "base64"
class OrdersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    skip_before_action :authorize, only: [:index, :create, :show]

    def index
        token = get_access_token
        
        url = URI("https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest")
        
        https = Net::HTTP.new(url.host, url.port);
        https.use_ssl = true
        
        request = Net::HTTP::Post.new(url)
        request["Authorization"] = "Bearer #{token}"
        request["Content-Type"] = "application/json"

        password = Base64.strict_encode64("174379bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919#{Time.now.strftime "%Y%m%d%H%M%S"}")
        request.body = {
            "BusinessShortCode": 174379,
            "Password": password,
            "Timestamp": "#{Time.now.strftime "%Y%m%d%H%M%S"}",
            "TransactionType": "CustomerPayBillOnline",
            "Amount": 1,
            "PartyA": 254706941217,
            "PartyB": 174379,
            "PhoneNumber": 254706941217,
            "CallBackURL": "https://mathe-food-api.herokuapp.com/mpesa/lipa-na-mpesa-callback",
            "AccountReference": "Test",
            "TransactionDesc": "Payment test" 
        }.to_json

        response = https.request(request)
        redirect_to "https://mathe-food-api.herokuapp.com/mpesa/lipa-na-mpesa-callback"
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

    # def callback_url
    #     url = URI("https://3702-102-140-225-96.ngrok.io/orders")
        
    #     https = Net::HTTP.new(url.host, url.port);
    #     https.use_ssl = true

    #     request = Net::HTTP::Get.new(url)
    #     request["Content-Type"] = "application/json"
    #     response = https.request(request)
    #     data=JSON.parse(response.body)
    #     data
    # end

    def get_access_token
        url = URI("https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials")
        
        https = Net::HTTP.new(url.host, url.port);
        https.use_ssl = true

        request = Net::HTTP::Get.new(url)
        enc = Base64.strict_encode64('fdkIze6JyJNzrStsbLabCZNdqnvoJ1OV:JsELP1GX9ugPNUkt')
        request["Authorization"] = "Basic #{enc}"
        response = https.request(request)

        data=JSON.parse(response.body)
        data['access_token']
    end

    def order_params
        params.permit(:name, :email, :location, :phone, :amount, :shipping, :user_id)
    end

    def record_not_found
        render json: { error: "Order not found" }, status: :not_found
    end
    
end
