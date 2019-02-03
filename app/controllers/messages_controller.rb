class MessagesController < ApplicationController
  before_action :require_token, only: [ :create ]

  def create 
    @conversation = @current_user.current_conversation
    @message = @conversation.messages.create( { 
      user: @current_user, 
      content: params.require( :content ) 
    } )

    data = { message: "new message", result: @message }
    
    ConversationsChannel.broadcast_to @conversation, serialize_response( data )

    render_result{ data }
  end

end
