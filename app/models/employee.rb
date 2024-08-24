class Employee < ApplicationRecord
  has_many :employee_factors
  has_many :absences
  has_many :employee_allowances

  def absences_between(start_date, end_date)
    self.absences.where(calendar_date: start_date..end_date)
  end

  def absence_days_in_month(month_number)
    the_year = Date.current.year
    start_date = Date.new(the_year, month_number, 1)
    end_date = start_date.end_of_month
    self.calculate_absence_days_between(start_date, end_date)
  end

  def engineering_factor_in_month(month_number)
    the_year = Date.current.year
    self.employee_factors.where(year: the_year, month: month_number).first&.engineering_factor
  end

  def allowances_in_year(year = Date.current.year)
    self.employee_allowances.find_by(year: year)
  end

  private

  def calculate_absence_days_between(start_date, end_date)
    self.absences_between(start_date, end_date).reduce(0) do |result, absence|
      absence.half_day ? result + 0.5 : result + 1
    end
  end
end
