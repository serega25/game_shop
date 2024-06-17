# frozen_string_literal: true

class GameKeysMailer < ApplicationMailer
  def send_keys_email
    @user_email = params[:user_email]
    @game_name = params[:game_name]
    @keys = params[:keys]

    mail(to: @user_email, subject: "Your Game Keys for #{@game_name}")
  end
end
