class SessionsController < ApplicationController
    skip_before_action :authorize, only: :create

    def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
            payload = {user_id: user.id, email: user.email}
            token = encode_token(payload)
            render json: {token: token}
        else
            render json: { errors: ["Invalid email or password"]}, status: :unauthorized
        end
    end

    # def destroy
    #     session.delete :user_id
    #     head :no_content
    # end

    def encode_token(payload)
        # don't forget to hide your secret in an environment variable
        JWT.encode(payload, 'my_s3cr3t')
    end
end
