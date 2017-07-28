class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.references :task_list, index: true, foreign_key: true

      t.string :value, null: false
      t.boolean :done, default: false
    end
  end
end
