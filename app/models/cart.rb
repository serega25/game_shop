class Cart < ApplicationRecord
  has_many :orderables, dependent: :delete_all
  has_many :games, through: :orderables

  def total
    orderables.to_a.sum { |orderable| orderable.total }
  end
end
