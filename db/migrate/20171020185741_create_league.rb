class CreateLeague < ActiveRecord::Migration[5.1]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :slug
      t.references :user, foreign_key: true

      t.timestamps null: false
    end
  end
end
