class Profile < ApplicationRecord
  belongs_to :user
  validates :nickname, presence: true
  validates :full_name, presence: true

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[nickname full_name user_id]
  end
end
