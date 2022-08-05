class ApplicationController < ActionController::API

    # include ActionController::Cookies
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    before_action :authorize

    private

    def authorize
        if decoded_token
            user_id = decoded_token[0]['user_id']
            @current_user = User.find_by(id: user_id)
            render json: { errors: ["Not authorized"] }, status: :unauthorized unless @current_user
        end
    end

    def auth_header
        request.headers['Authorization']
    end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, 'my_s3cr3t', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

    def render_unprocessable_entity_response(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end
end
