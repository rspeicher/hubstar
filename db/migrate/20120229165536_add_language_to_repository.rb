class AddLanguageToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :language, :string
  end
end
