class ChangeDescriptionToText < ActiveRecord::Migration
  def change
    change_column :repositories, :description, :text
  end
end
