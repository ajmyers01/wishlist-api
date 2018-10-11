class RemoveIsActiveFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :is_active
  end
end
