class SoundsController < ApplicationController

  get "/sounds/new" do
    erb :"/sounds/new"
  end

  post "/sounds" do
    @sound = Sound.create(params)
    @user = User.find(session[:id])
    @sound.user = @user
    @sound.save
    redirect "/sounds/#{@sound.slug}"
  end

  get "/sounds/:slug" do
    @sound = Sound.find_by_slug(params[:slug])
    erb :"sounds/view"
  end

end
