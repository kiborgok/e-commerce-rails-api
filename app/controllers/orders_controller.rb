require "uri"
require "net/http"
require "base64"
require 'rest-client'
class OrdersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    skip_before_action :authorize, only: [:index, :create, :show]

    def index
        # orders = Order.all
        # render json: orders, include: user, status: ok
        url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
        token = Base64.encode64("lGKZrbQ0qCb8WABGHCyEFSKzik8x6R4j:NJDbFf9npCoLnyLS")
        res = RestClient::Request.execute(
            :method => :get,
            :url => url,
            :verify_ssl =>  false,
            :headers => { 
                :Authorization => "Bearer #{token}", 
                :content_type => :json,
                :accept => :json
            }
        )
        # url = URI("https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials")

        # https = Net::HTTP.new(url.host, url.port);
        # https.use_ssl = true

        # request = Net::HTTP::Get.new(url)
        # request["Authorization"] = "Bearer "+ Base64.encode64("lGKZrbQ0qCb8WABGHCyEFSKzik8x6R4j:NJDbFf9npCoLnyLS")

        # response = https.request(request)
        render json: res.body
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
