class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        login @user
        remember @user
        redirect_to root_path
      else
        render 'new'
      end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
      if @user && @user.update_attributes(user_params)
        flash[:notice] = 'Profile has been successfully updated'
        redirect_to user_path(@user)
      else
        render 'edit'
      end
  end

  def show
    @user = User.find(params[:id])
    @activities = @user.activities.order(created_at: :desc).page(params[:page]).per(6)
  end

  def index
    if params[:search_user]
      @users = User.where('name LIKE ?', "%#{params[:search_user]}%").page(params[:page]).per(8)
    else
      @users = User.page(params[:page]).per(8)
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(10)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(10)
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation, :avatar)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end
