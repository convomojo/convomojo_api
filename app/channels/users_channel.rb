class UsersChannel < ApplicationCable::Channel
  def subscribed
    user = User.find_by_token(params[:token])
    stream_for user
  end

  def unsubscribed
  end
end
