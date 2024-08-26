class AlterAbsenceTypeToEnum < ActiveRecord::Migration[7.1]
  def change
    remove_column :absences, :absence_type
    add_column :absences, :absence_type, :integer, default: 0
  end
end
