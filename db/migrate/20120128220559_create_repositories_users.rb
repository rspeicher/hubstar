class CreateRepositoriesUsers < ActiveRecord::Migration
  def change
    create_table :repositories_users do |t|
      t.references :user
      t.references :repository
    end

    add_index :repositories_users, :user_id
    add_index :repositories_users, :repository_id
  end
end
