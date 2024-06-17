# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?


# Create 10 sample games


covers = %w[cover1.jpg cover2.jpg cover3.jpeg]

pictures = %w[picture1.jpeg picture2.jpeg picture3.jpg picture4.jpeg picture5.jpeg picture6.jpeg ]

25.times do
  genre = Genre.create!(name: Faker::Game.genre)

  game = Game.create!(
    name: Faker::Game.title,
    description: Faker::Lorem.paragraph,
    platforms: Faker::Game.platform,
    distributor: Faker::Company.name,
    developer: Faker::Company.name,
    price_for_one: rand(10.0..100.0).round(2)
  )

  game.genres << genre

  # Attach cover
  game.cover.attach(io: File.open("app/assets/images/#{covers.sample}"), filename: 'cover.jpg', content_type: 'image/*')

  # Attach pictures
  2.times do
    game.pictures.attach(io: File.open("app/assets/images/#{pictures.sample}"), filename: "picture.jpeg", content_type: 'image/*')
  end
end
