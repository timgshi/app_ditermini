class PhotosController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def index
  end

  def new
  	@photo = Photo.new
  end

  def create
  	@photo = Photo.new #current_user.photos.build(param[:photo])
    name = params[:photo][:image].original_filename
    @photo.update_attributes(user_id: current_user.id, filename: name, caption: params[:photo][:caption])
    if @photo.save
      path = File.join("public/images", name)
      File.open(path, "wb") do |f|
        f.write(params[:photo][:image].read())
      end
  		flash[:success] = "Photo uploaded!"
  		redirect_to root_url
  	else 
  		render 'new'
  	end
  end

  def destroy
    @photo.destroy
    redirect_to root_url
  end

  private

    def correct_user
      @photo = current_user.photos.find_by_id(params[:id])
      redirect_to root_url if @photo.nil?
    end
end