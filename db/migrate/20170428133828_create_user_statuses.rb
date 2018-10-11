class CreateUserStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :user_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
