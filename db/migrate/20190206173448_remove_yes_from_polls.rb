class RemoveYesFromPolls < ActiveRecord::Migration[5.2]
  def change
    remove_column :polls, :yes, :integer
  end
end