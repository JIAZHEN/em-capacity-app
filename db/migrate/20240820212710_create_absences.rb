class CreateAbsences < ActiveRecord::Migration[7.1]
  def change
    create_table :absences do |t|
      t.references :employee, null: false, foreign_key: true
      t.date :calendar_date
      t.boolean :half_day
      t.string :absence_type

      t.timestamps
    end
  end
end
