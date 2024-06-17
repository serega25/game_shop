class GamesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  def show
    @game = Game.find(params[:id])
  end
end
