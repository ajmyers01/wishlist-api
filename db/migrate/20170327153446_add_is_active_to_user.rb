class AddIsActiveToUser < ActiveRecord::Migration[5.0]
  def change
    # All newly created users are set to active
    add_column :users, :is_active, :boolean, default: true
  end
end
