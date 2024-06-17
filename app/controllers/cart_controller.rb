class CartController < ApplicationController
  def show
    @render_cart = false
  end

  def add
    @game = Game.find_by(id: params[:id])
    quantity = params[:quantity].to_i

    if @game.remaining_keys >= quantity
      current_orderable = @cart.orderables.find_by(game_id: @game.id)

      if current_orderable && quantity > 0
        current_orderable.update(quantity: current_orderable.quantity = quantity)
      elsif quantity <= 0
        current_orderable.destroy
      else
        @cart.orderables.create(game: @game, quantity:)
      end

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [turbo_stream.replace('cart',
                                                     partial: 'cart/cart',
                                                     locals: { cart: @cart }),
                                turbo_stream.replace(@game),
                                turbo_stream.replace('cart-link', partial: 'cart/cart_link')]
        end
      end
    else
      flash[:error] = "Sorry but amount you want to buy exceeds available in stock"
      redirect_to cart_path, data: {turbo: false}
    end
  end

  def remove
    Orderable.find_by(id: params[:id]).destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.replace('cart',
                                                   partial: 'cart/cart',
                                                   locals: { cart: @cart }),
                              turbo_stream.replace('cart-link', partial: 'cart/cart_link')]
      end
    end
  end

  def create_order
    unless @cart.orderables.empty?

      current_user.set_payment_processor :stripe
      current_user.payment_processor.customer

      total_amount = (@cart.total * 100).to_i # Stripe expects amount in cents

      @checkout_session = @checkout_session = current_user
                                                .payment_processor
                                                .checkout(
                                                  mode: 'payment',
                                                  line_items: [
                                                    {
                                                     price_data:
                                                       {
                                                       currency: 'usd',
                                                       unit_amount: total_amount,
                                                       product_data:
                                                         { name: 'Game Shop Cart Payment'}
                                                       },
                                                     quantity: 1
                                                     }],
                                                  success_url: checkouts_success_url,
                                                )

      session[:order_data] = {
        user_id: current_user.id,
        orderables: @cart.orderables.map { |orderable| {game_id: orderable.game_id, quantity: orderable.quantity, price: orderable.game.price_for_one} },
        total_price: @cart.total
      }
      @cart.orderables.destroy_all

      redirect_to @checkout_session.url, allow_other_host: true
    else
      flash[:error] = "Cart is Empty"
      redirect_to root_path
    end
  end
end
