class StaticPagesController < ApplicationController
  def home
  	@photo = current_user.photos.build if signed_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
