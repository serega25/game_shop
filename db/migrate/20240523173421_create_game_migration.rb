class CreateGameMigration < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.string :description
      t.string :platforms
      t.string :genre
      t.string :distributor
      t.string :developer
      t.decimal :price_for_one, precision: 10, scale: 2

      t.timestamps
    end
  end
end
