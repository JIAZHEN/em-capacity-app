class Employee < ApplicationRecord
  has_many :employee_factors
  has_many :absences

  def absences_between(start_date, end_date)
    self.absences.where(calendar_date: start_date..end_date)
  end

  def absence_days_in_month(month_number)
    the_year = Date.current.year
    start_date = Date.new(the_year, month_number, 1)
    end_date = start_date.end_of_month

    self.absences_between(start_date, end_date).reduce(0) do |result, absence|
      absence.half_day ? result + 0.5 : result + 1
    end
  end
end
