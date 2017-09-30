class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user
      t.belongs_to :question

      t.timestamps
    end
    add_index :subscriptions, [:user_id, :question_id], unique: true
  end
end
