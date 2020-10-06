class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.belongs_to :user
      t.belongs_to :poll
      t.boolean :answ
    end
    add_index :answers, [:poll_id, :user_id], unique: true
  end
end
