class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  def home
    @games = Game.all.page(params[:page]).per(15)
  end
end
