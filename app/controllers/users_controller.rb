class UsersController < ApplicationController

    skip_before_action :authorize, only: :create

    def create
        user = User.create(user_params)
        if user.valid?
            payload = {user_id: user.id, email: user.email}
            token = encode_token(payload)
            render json: {token: token}, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    def show
        render json: @current_user
    end

    private

    def encode_token(payload)
        # don't forget to hide your secret in an environment variable
        JWT.encode(payload, 'my_s3cr3t')
    end

    def user_params
        params.permit(:username, :email, :password, :password_confirmation)
    end
end
