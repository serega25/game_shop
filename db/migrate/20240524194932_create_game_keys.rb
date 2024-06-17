class CreateGameKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :game_keys do |t|
      t.string :key, null: false
      t.belongs_to :game, foreign_key: true
      t.timestamps
    end
  end
end
