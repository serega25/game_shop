class CreateGameGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :game_genres do |t|
      t.belongs_to :game, null: false, foreign_key: true
      t.belongs_to :genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
