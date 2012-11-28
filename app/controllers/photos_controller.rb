class PhotosController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :show]
  before_filter :correct_user,   only: :destroy

  def index
  end

  def new
  	@photo = Photo.new

  end

  def create
  	# @photo = Photo.new #current_user.photos.build(param[:photo])
    # @photo.update_attributes(user_id: current_user.id, caption: params[:photo][:caption])
    @photo = Photo.create(params[:photo])
    @photo.user = current_user
    # @photo.update_attributes(params[:photo])
    if @photo.save
  		flash[:success] = "Photo uploaded!"
      @msg = "uploaded a photo!"
      current_user.followers.each do |other_user|
        current_user.notify!(other_user, @msg)
  		end
      redirect_to @photo
  	else
      print @photo.errors.full_messages
      flash[:error] = @photo.errors.full_messages
  		redirect_to root_url
  	end
  end

  def show
    @photo = Photo.find_by_id(params[:id])
    @receivers = []
  end

# NOT SURE WHICH TEMPLATE TO PUT THIS IN YET, BUT THE CODE WILL GRAB LOCATION
# <script>

# $(document).ready(function() {

#   function success(position) {
#     var lat = position.coords.latitude;
#     var lng = position.coords.longitude;
#   }

#   function error(msg) {
#     var errMsg = typeof msg == 'string' ? msg : "Geolocation failed";
#     $('#msg').html(errMsg);
#   }

#   if (navigator.geolocation) {
#       navigator.geolocation.getCurrentPosition(success, error);
#   } else {
#       error('Geolocation not supported');
#   }

# });

# </script>

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
