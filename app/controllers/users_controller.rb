class UsersController < ApplicationController
  # before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers, :notifications]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def show
  	@user = User.find(params[:id])
    @photos = @user.photos.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Determini!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def notifiers
    @title = "Notifications"
    @user = User.find(params[:id])
    @notifications = @user.reverse_notifications.paginate(page: params[:page])
    render 'show_notifications'
  end

  def vote
    # curUser = User.find_by_id(session[:user_id])
    photo = Photo.find_by_id(params[:photoId])
    if params[:voteYes] == "1"
      msg = "voted for your outfit!"
      current_user.vote_exclusively_for(photo)
      current_user.notify!(photo.user, msg)
    else
      msg = "voted against your outfit!"
      current_user.vote_exclusively_against(photo)
      current_user.notify!(photo.user, msg)
    end
    responseJSON = {:yes => photo.votes_for, :no => photo.votes_against, :photo_id => photo.id, :voted_for => current_user.voted_for?(photo)}
    render :layout => false, :status => :ok, :json => responseJSON
  end

  def findUsers
    prefix=params[:substring].downcase
    users=User.find(:all)
    @selectedUsers=[]
    for user in users
     if (user.name.downcase).include?(prefix) or (user.phone_number != nil and user.phone_number.include?(prefix))
       @selectedUsers<<user
      end
    end
    if params[:forsms] == "1"
      render :partial => "findUsersSms"
    else
      render :partial=>"findUsers"
    end
  end 

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
