class UsersController < ApplicationController

  get "/login" do
    erb :index
  end

  post "/signup" do
    @user = User.create(params)
    session[:id] = @user.id
    redirect :"users/sounds"
  end

  get "/users/sounds" do
    if !!session[:id]
      @user = User.find(session[:id])
      erb :"/users/show"
    else
      redirect "/login"
    end
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user
      session[:id] = @user.id
      redirect "users/sounds"
    else
      flash[:message] = "That user does not exist, please signup for a new account."
      redirect "/"
    end
  end

  post "/logout" do
    session.clear
    redirect "/login"
  end


end
