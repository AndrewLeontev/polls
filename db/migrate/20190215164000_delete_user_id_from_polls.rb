class DeleteUserIdFromPolls < ActiveRecord::Migration[5.2]
  def change
    remove_column :polls, :user_id, :integer
  end
end