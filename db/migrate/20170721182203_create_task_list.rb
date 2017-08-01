class CreateTaskList < ActiveRecord::Migration[5.1]
  def change
    create_table :task_lists do |t|
      t.references :user, index: true, foreign_key: true

      t.string :title, null: false
    end
  end
end
