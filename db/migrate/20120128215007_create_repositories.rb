class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :description
      t.integer :watchers
      t.integer :forks
      t.timestamps
    end

    add_index :repositories, :name, :unique => true
  end
end
