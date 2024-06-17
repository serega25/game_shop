class Game < ApplicationRecord
  has_many :order_items
  has_many :orders, through: :order_items

  has_many :orderables
  has_many :carts, through: :orderables

  has_one_attached :cover
  has_many_attached :pictures

  #validates :genre_ids, presence: true
  validates :name, presence: true, uniqueness: true
  validates :price_for_one, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1000.0 }

  has_many :game_genres, dependent: :delete_all
  has_many :genres, through: :game_genres

  has_many :game_keys

  # Define which associations are searchable
  def self.ransackable_associations(auth_object = nil)
    %w[genres cover]
  end
  #
  def self.ransackable_attributes(auth_object = nil)
    %w[name platforms genre distributor developer]
  end

  def cover_image(width, height)
    if cover.attached?
      cover.variant(format: :png, resize_to_fill: [width, height]).processed
    else
      ""
    end
  end

  def pictures_thumbnails(width, height)
    if pictures.attached?
      pictures.map do |picture|
        picture.variant(format: :png, resize_to_fill: [width, height]).processed
      end
    else
      []
    end
  end

  def remaining_keys
    game_keys.count
  end
end
