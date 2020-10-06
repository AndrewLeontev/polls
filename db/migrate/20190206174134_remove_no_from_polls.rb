class RemoveNoFromPolls < ActiveRecord::Migration[5.2]
  def change
    remove_column :polls, :no, :integer
  end
end