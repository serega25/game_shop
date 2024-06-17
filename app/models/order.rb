class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :games, through: :order_items

  after_create :send_game_keys_email

  def self.ransackable_associations(auth_object = nil)
    %w[games order_items user]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id id_value status total_price updated_at user_id]
  end

  private

  def send_game_keys_email
    # Retrieve user's email
    user_email = user.email

    # Hash to store game keys sent in the email
    sent_game_keys = {}

    # Retrieve game keys for each order item
    order_items.each do |order_item|
      game = order_item.game
      quantity = order_item.quantity

      # Retrieve the required number of keys for the game
      keys = game.game_keys.limit(quantity).pluck(:key)

      # Send email containing keys to user's email
      GameKeysMailer.with(user_email: user_email, game_name: game.name, keys: keys).send_keys_email.deliver_now

      # Store sent game keys in the hash
      sent_game_keys[game.id] = keys

      # Delete sent game keys from the database
      game.game_keys.where(key: keys).destroy_all
    end
  end
end
