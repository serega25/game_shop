class OrdersController < ApplicationController
  def index
    @user = User.find(params[:user_id])

    @orders = @user.orders.page(params[:page]).per(14)
  end
end
