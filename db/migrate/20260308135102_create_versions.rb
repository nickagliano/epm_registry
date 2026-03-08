class CreateVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :versions do |t|
      t.references :package, null: false, foreign_key: true
      t.string :version
      t.string :git_url
      t.string :commit_sha
      t.string :manifest_hash
      t.boolean :yanked, null: false, default: false
      t.string :platforms, array: true, default: []
      t.jsonb :system_deps

      t.timestamps
    end
  end
end
