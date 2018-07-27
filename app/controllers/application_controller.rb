require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  set :views, 'app/views'
  enable :sessions
    set :session_secret, "secret"



  get "/" do
    if is_logged_in?(session)
      @user = User.find(session[:id])
      redirect "/users/sounds"
    else
      erb :index
    end
  end

  helpers do
    def current_user(arg)
      @user = User.find_by(id: arg[:id])
      @user
    end

    def is_logged_in?(arg)
      !!arg[:id]
    end



  end


end
