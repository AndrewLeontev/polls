class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.integer :author_id
      t.string :question
      t.integer :yes,  :default => 0
      t.integer :no, :default => 0
    end
  end
end
