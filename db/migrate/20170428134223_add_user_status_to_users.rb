class AddUserStatusToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :user_status, index: true, foreign_key: true
  end
end
