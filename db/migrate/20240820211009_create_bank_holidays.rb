class CreateBankHolidays < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_holidays do |t|
      t.date :calendar_date
      t.integer :year

      t.timestamps
    end
  end
end
