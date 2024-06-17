class Orderable < ApplicationRecord
  belongs_to :game
  belongs_to :cart

  def total
    game.price_for_one * quantity
  end
end
