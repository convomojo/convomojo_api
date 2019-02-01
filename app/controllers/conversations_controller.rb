class ConversationsController < ApplicationController
  before_action :require_token, only: [ :create, :destroy ]

  def create 
    @conversation = Conversation.match || Conversation.create
    @conversation.users << @current_user

    data = { 
      message: "conversation created", 
      result: {
        conversation: @conversation, 
        users: @conversation.users
      }
    }

    ConversationsChannel.broadcast_to @conversation, serialize_response( data )
    render_response{ data }
  end

  def destroy 
    @conversation = @current_user.current_conversation
    if @conversation
      @conversation.update_attributes!( { ended_at: DateTime.new } )
      
      disconnect_message = { message: "conversation ended", result: @conversation }
      ConversationsChannel.broadcast_to @conversation, serialize_response( disconnect_message )

      render_response{ disconnect_message }
    else 
      render_response do 
        { 
          status: :not_found, 
          message: "error", 
          errors: [ "no current conversation for user" ] 
        } 
      end
    end
  end

end
