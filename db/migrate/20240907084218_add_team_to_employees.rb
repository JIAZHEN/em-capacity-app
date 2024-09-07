class AddTeamToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :team, :string, default: "Engineering"
    add_index :employees, :team
  end
end
