class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def create
    super do |resource|
      if resource.persisted?
        resource.create_profile(profile_params)
      end
    end
  end

  private

  def profile_params
    params.require(:user).require(:profile).permit(:nickname, :full_name)
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:profile, profile_attributes: [:nickname, :full_name]])
  end
end
