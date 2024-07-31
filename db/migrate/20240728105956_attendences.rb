class Attendences < ActiveRecord::Migration[7.0]
  def change
    create_table :attendences do |t|
      t.integer :working_hours
      t.integer :leaves
      t.boolean :attended
      t.date :date, null: false
      t.references :employee, null: false, foreign_key: true
      t.timestamps
    end
    add_index :attendences, [:employee_id, :date], unique: true
  end
end
