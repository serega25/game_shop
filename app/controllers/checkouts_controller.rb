# frozen_string_literal: true

class CheckoutsController < ApplicationController
  def success
    session_id = params[:session_id]

    order_data = session[:order_data]
    stripe_payment_intent_id = Stripe::Checkout::Session.retrieve(session_id).payment_intent

    order = Order.new(
      user_id: order_data['user_id'],
      total_price: order_data['total_price'],
      status: "completed",
      stripe_payment_intent_id: stripe_payment_intent_id
    )

    order_data["orderables"].each do |orderable_data|
      order.order_items.build(
        game_id: orderable_data["game_id"],
        quantity: orderable_data["quantity"],
        price: orderable_data["price"]
      )
    end

    if order.save
      session[:order_data] = nil
      redirect_to orders_index_path(user_id: current_user.id), notice: "Order created successfully."
    else
      Stripe::Refund.create({ payment_intent: stripe_payment_intent_id })
      flash[:alert] = "Appointment creation failed. Payment has been refunded."
      redirect_to root_path
    end
  end
end
