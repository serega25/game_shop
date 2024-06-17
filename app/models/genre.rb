class Genre < ApplicationRecord
  validates :name, presence:  true, uniqueness: true
  has_many :game_genres
  has_many :games, through: :game_genres

  def self.ransackable_associations(auth_object = nil)
    ["games"]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id id_value name updated_at]
  end
end
