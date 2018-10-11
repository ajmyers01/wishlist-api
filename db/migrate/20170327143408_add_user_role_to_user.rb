class AddUserRoleToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :user_role, foreign_key: true
  end
end
