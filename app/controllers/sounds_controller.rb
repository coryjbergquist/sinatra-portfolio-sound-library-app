
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
      flash[:message] = "You do not have a sound by that name."
      redirect "/users/sounds"
    end
  end

  patch "/sounds/:slug" do
    @sound = Sound.find_by_slug(params[:slug])
    @sound.update(name: params[:name], description: params[:description])
    @sound.save
    flash[:message] = "This is your newly edited sound"
    redirect "/sounds/#{@sound.slug}"
  end

  delete "/sounds/:slug" do
    @sound = Sound.find_by_slug(params[:slug])
    filename = @sound.filename
    if File.exist?("public/#{filename}")
      File.delete("public/#{filename}")
      @sound.destroy
    else
      @sound.destroy
    end
    flash[:message] = "Your sound has been deleted"
    redirect "/users/sounds"
  end


  post "/sounds" do
    if !params.include?("file")
      flash[:message] = "Please add a file to upload"
      redirect "/sounds/new"
    end
    @user = User.find(session[:id])
    @sound = @user.sounds.create(name: params[:name], description: params[:description], filename: params[:file][:filename])
    if !@sound.errors.any?
      @sound.file = params[:file]
      redirect "/sounds/#{@sound.slug}"
    else
      errors = @sound.errors.full_messages
      flash[:message] = errors.join("\n")
      redirect "/sounds/new"
    end
  end

  get "/sounds/:slug" do
    @user = User.find(session[:id])
    @sound = @user.sounds.find_by_slug(params[:slug])
    if @user.sounds.include?(@sound)
      @filename = @sound.filename
      erb :"/sounds/view"
    else
      flash[:message] = "You do not have a sound with that title, would you like to create one?"
      redirect "sounds/new"
    end
  end

end
