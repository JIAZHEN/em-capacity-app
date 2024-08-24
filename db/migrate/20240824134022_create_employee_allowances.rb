class CreateEmployeeAllowances < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_allowances do |t|
      t.references :employee, null: false, foreign_key: true
      t.integer :year
      t.integer :holiday_allowance
      t.integer :sick_leave_allowance

      t.timestamps
    end
  end
end
