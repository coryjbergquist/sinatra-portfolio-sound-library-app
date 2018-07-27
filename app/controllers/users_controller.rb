class UsersController < ApplicationController

  get "/login" do
    erb :index
  end

  post "/signup" do
    @username = User.find_by(username: params[:username])
  if @username
      flash[:message] = "A user by that name already exists"
      redirect "/login"
    else
      @user = User.create(params)
      if !@user.errors.any?
        session[:id] = @user.id
        redirect :"users/sounds"
      else
        errors = @user.errors.map do |attribute, message|
          "#{attribute} #{message}"
        end
        flash[:message] = errors
        redirect "/login"
      end
    end
  end

  get "/users/sounds" do
    if self.is_logged_in?(session) && session[:id] == self.current_user(session).id
      @user = User.find(session[:id])
      @sounds = @user.sounds
      erb :"/users/show"
    else
      redirect "/login"
    end
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id
      redirect "users/sounds"
    else
      flash[:message] = "That user does not exist, please signup for a new account."
      redirect "/"
    end
  end

  post "/logout" do
    session.clear
    redirect "/"
  end


end
