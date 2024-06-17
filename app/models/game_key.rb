class GameKey < ApplicationRecord
  belongs_to :game

  def self.ransackable_associations(auth_object = nil)
    ["game"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "game_id", "id", "id_value", "key", "updated_at"]
  end
end
