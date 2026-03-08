class CreatePackages < ActiveRecord::Migration[8.1]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :description
      t.string :license
      t.string :homepage
      t.string :repository
      t.string :authors, array: true, default: []

      t.timestamps
    end
    add_index :packages, :name, unique: true
  end
end
