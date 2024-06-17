# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user
  before_action :check_user, only: [:update, :update_profile, :update_password, :update_avatar]

  def show

  end

  def update
    if @user.update(user_params)
      flash[:success] = "Go to new Email to confirm change"
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join(", ")
      redirect_to user_path(@user)
    end
  end

  def update_avatar
    if @user.update(user_params)
      flash[:success] = "Avatar Updated"
      redirect_to user_path(@user)
    else
      flash[:error] = "Cant Update Avatar"
      redirect_to user_path(@user)
    end
  end

  def update_password
    if @user.valid_password?(params[:user][:current_password])
      if @user.update(user_password_params)
        bypass_sign_in(@user)
        flash[:success] = "Password successfully changed"
        redirect_to user_path(@user)
      else
        flash[:error] = @user.errors.full_messages.join(", ")
        redirect_to user_path(@user)
      end
    else
      flash[:error] = "Current Password is invalid"
      redirect_to user_path(@user)
    end
  end

  def update_profile
    @profile = Profile.find(params[:id])

    if @profile.update(profile_params)
      flash[:success] = "Profile updated"
      redirect_to user_path(@user)
    else
      flash[:error] = @profile.errors.full_messages.join(", ")
      redirect_to user_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :avatar)
  end

  def profile_params
    params.require(:profile).permit(:nickname, :full_name)
  end

  def set_user
    if User.exists?(params[:id])
      @user = User.find(params[:id])
    else
      redirect_to root_path
      flash[:error] = "No such User"
    end
  end

  def check_user
    if @user != current_user
      redirect_to root_path
      flash[:error] = "You dont have rights for this"
    end
  end

  def user_password_params # users controller
    params.require(:user).permit(:password, :password_confirmation)
  end
end
