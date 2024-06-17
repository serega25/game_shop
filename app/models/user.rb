class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_one :profile, foreign_key: :user_id, dependent: :destroy
  has_many :orders, foreign_key: :user_id, dependent: :destroy

  has_one_attached :avatar
  pay_customer stripe_attributes: :stripe_attributes

  def self.ransackable_associations(auth_object = nil)
    %w[profile orders]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[email created_at]
  end

  def avatar_image(width, height)
    if avatar.attached?
      avatar.variant(format: :png, resize_to_fill: [width, height]).processed
    else
      attach_default.variant(format: :png, resize_to_fill: [width, height]).processed
    end
  end

  def self.from_omniauth(access_token)
    user = User.where(email: access_token.info.email).first
    unless user
      user = User.create(email: access_token.info.email,
                         password: Devise.friendly_token[0, 20])

      user.create_profile(full_name: access_token.info.name,
                          nickname: access_token.info.name)
    end

    user.skip_confirmation!
    user
  end

  private

  def stripe_attributes(pay_customer)
    {
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: id
      }
    }
  end

  def attach_default
    unless avatar.attached?
      begin
        image_path = Rails.root.join('app', 'assets', 'images', 'default_avatar.jpg')
        image = File.open(image_path)
        avatar.attach(io: image, filename: 'default_avatar.jpg', content_type: 'image/jpeg')
      end
    end
  end
end
