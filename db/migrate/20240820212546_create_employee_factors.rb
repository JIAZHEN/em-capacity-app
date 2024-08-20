class CreateEmployeeFactors < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_factors do |t|
      t.references :employee, null: false, foreign_key: true
      t.float :factor
      t.integer :year
      t.integer :month

      t.timestamps
    end
  end
end
