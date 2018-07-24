
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
  else
    @sound = Sound.find_by(name: params[:name])
    if @sound
      flash[:message] = "That sound name already exists, choose a different name."
      redirect "/sounds/new"
    else
      @filename = params[:file][:filename]
      file = params[:file][:tempfile]
      File.open("./public/#{@filename}", 'wb') do |f|
        f.write(file.read)
      end
      @sound = Sound.create(name: params[:name], description: params[:description], filename: @filename)
      if !@sound.errors.any?
        @user = User.find(session[:id])
        @sound.user = @user
        @sound.save
        redirect "/sounds/#{@sound.slug}"
      else
        errors = @sound.errors.map do |attribute, message|
                  "#{attribute} #{message}"
                  end
          flash[:message] = errors
          redirect "/sounds/new"
      end
    end
  end
  end

  get "/sounds/:slug" do
    @sound = Sound.find_by_slug(params[:slug])
    @filename = @sound.filename
    @user = User.find(session[:id])
    if @user.sounds.include?(@sound)
      erb :"/sounds/view"
    else
      flash[:message] = "You do not have a sound with that title, would you like to create one?"
      redirect "sounds/new"
    end
  end

end
