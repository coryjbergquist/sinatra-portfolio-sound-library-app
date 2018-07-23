class SoundsController < ApplicationController
  use Rack::Flash

  get "/sounds/new" do
    erb :"/sounds/new"
  end

  post "/sounds" do
    #find sound, if there is a sound, raise error saying a sound with that name already exists
    @sound = Sound.find_by(name: params[:name])
    if @sound
      flash[:message] = "That sound name already exists, choose a different name."
      redirect "/sounds/new"
    else
      @sound = Sound.create(params)
      @user = User.find(session[:id])
      @sound.user = @user
      @sound.save
      redirect "/sounds/#{@sound.slug}"
    end
  end

  get "/sounds/:slug" do
    @sound = Sound.find_by_slug(params[:slug])
    erb :"sounds/view"
  end

end
