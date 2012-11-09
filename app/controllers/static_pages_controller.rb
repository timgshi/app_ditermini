class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@photo = current_user.photos.build
      @feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end

  def feed
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def help
  end

  def about
  end

  def contact
  end
end
