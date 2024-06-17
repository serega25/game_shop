class AddProfileToUser < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :nickname, null: false
      t.string :full_name, null: false
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
