class SessionsController < ApplicationController
  def show 
    @conversation = Conversation.find( params[:id] ) 
    render_result do 
      {
        result: {
          conversation: @conversation,
          users: @conversation.users, 
          messages: @conversation.messages
        }
      }
    end
  end

  def create 
    @user = User.find_by_email( session_params[ :email ] )
    if @user 
      if @user.authenticate( session_params[ :password ] )
        render_result { { result: @user, message: "logged in" } }
      else 
        render_result( :unauthorized ) do 
          {
            message: :unauthorized,
            status: :error,
            errors: { password: [ "incorrect password" ] }
          }
        end
      end
    else 
      render_result( :unauthorized ) do 
          {
            message: :unauthorized,
            status: :error,
            errors: { email: [ "incorrect email" ] }
          }
        end
    end
  end

  private; def session_params 
    @session_params ||= {
      email: params.require( :email ),
      password: params.require( :password )
    }
  end
end
