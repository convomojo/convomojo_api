class UsersController < ApplicationController
  before_action :require_token, only: [ :index, :show ]
  before_action :set_user, only: [ :show ]

  def index 
    render_result{ { result: @current_user } }    
  end

  def show 
    render_result{ { result: @user } }
  end 

  def create 
    @user = User.create!(user_params)
    render_result{ { result: @user, message: 'user created' } }
  end 

  private; def user_params 
    params.require( :user ).permit( :username, :email, :password )
  end

  private; def set_user 
    @user = User.find( params[:id ])
  end
end
