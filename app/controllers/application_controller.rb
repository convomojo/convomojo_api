class ApplicationController < ActionController::API
  before_action :init_message

  private; def init_message 
    @message = {
      message: "ok",
      status: :ok
    }
  end

  private; def serialize_response( response )
    @message.merge( response ).to_json
  end

  private; def require_token 
    token = params.require( :token )
    @current_user = User.find_by_token( token ) 
    unless @current_user
      render_result( :unauthorized ) do 
        {
          message: :unauthorized,
          status: :error,
          errors: [ "invalid token" ]
        }
      end
    end
  end

  private; def render_result( status = :ok )
    @message = @message.merge( yield ) if block_given?
    render json: @message.to_json, status: status
  end

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    render_result( :unprocessable_entity ) do
      { 
        message: :unprocessable_entity, 
        status: :error, 
        errors: [ parameter_missing_exception ] 
      }
    end
  end

  rescue_from(ActiveRecord::RecordNotFound) do |missing_record_exception|
    render_result( :not_found ) do 
      {
        message: :not_found,
        status: :error,
        errors: [ missing_record_exception ]
      }
    end
  end

  rescue_from(ActiveRecord::RecordInvalid) do |invalid_record_exception|
    errors = invalid_record_exception.record.errors.messages.keys.reduce({}) do | obj, key | 
      obj[key] = invalid_record_exception.record.errors.messages[key].uniq 
      obj
    end

    render_result( :bad_request ) do 
      {
        message: :bad_request,
        status: :error,
        errors: errors
      }
    end
  end
end
