class SoundsController < ApplicationController
  use Rack::Flash

  get "/sounds/new" do
    erb :"/sounds/new"
  end

  get "/sounds/:slug/edit" do
    @user = User.find(session[:id])
    @sound = Sound.find_by_slug(params[:slug])
    if @user.sounds.include?(@sound)
      erb :"sounds/edit"
    else
      redirect "/users/sounds"
    end
  end

  patch "/sounds/:slug" do
    @sound = Sound.find_by_slug(params[:slug])
    @sound.update(name: params[:name], description: params[:description])
    @sound.save
    redirect "/sounds/#{@sound.slug}"
  end

  delete "/sounds/:slug" do
    @sound = Sound.find_by_slug(params[:slug])
    @sound.destroy
    redirect "/users/sounds"
  end


  post "/sounds" do
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
    @user = User.find(session[:id])
    if @user.sounds.include?(@sound)
      erb :"/sounds/view"
    else
      flash[:message] = "You do not have a sound with that title, would you like to create one?"
      redirect "sounds/new"
    end
  end

end
