class PhotosController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def index
  end

  def new
  	@photo = Photo.new
  end

  def create
  	@photo = current_user.photos.build(param[:photo])
  	if @photo.save
  		flash[:success] = "Photo uploaded!"
  		redirect_to @photo
  	else 
  		render 'new'
  	end
  end

  def destroy
    @photo.destroy
    redirect_to root_url
  end
end