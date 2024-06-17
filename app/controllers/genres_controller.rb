class GenresController < ApplicationController

  skip_before_action :authenticate_user!, only: [:show]

  def show
    @genre = Genre.find(params[:id])

    @games = @genre.games.page(params[:page]).per(14)

  end
end
