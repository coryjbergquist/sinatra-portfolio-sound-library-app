require './config/environment'

class ApplicationController < Sinatra::Base
  set :views, 'app/views'


  get "/" do
    erb :hello
  end

end
