class Employee < ApplicationRecord
  has_many :employee_factors
  has_many :absences
  has_many :employee_allowances

  def absences_between(start_date, end_date)
    self.absences.where(calendar_date: start_date..end_date)
  end

  def holidays_between(start_date, end_date)
    self.absences.where(calendar_date: start_date..end_date, absence_type: Absence.absence_types[:holiday])
  end

  def absence_days_in_month(month_number)
    the_year = Date.current.year
    start_date = Date.new(the_year, month_number, 1)
    end_date = start_date.end_of_month
    absences = self.absences_between(start_date, end_date)
    self._calculate_absence_days(absences)
  end

  def absence_days_between(start_date, end_date)
    absences = self.absences_between(start_date, end_date)
    self._calculate_absence_days(absences)
  end

  def engineering_factor_in_month(month_number)
    the_year = Date.current.year
    self.employee_factors.where(year: the_year, month: month_number).first&.factor
  end

  def engineering_factors_between(start_date, end_date)
    factors = self.employee_factors
                  .where("TO_DATE('' || year || month, 'YYYYMM') >= ?", start_date.beginning_of_month)
                  .where("TO_DATE('' || year || month, 'YYYYMM') <= ?", end_date.end_of_month)
    
    factors.reduce({}) do |result, factor|
      result["#{factor.year}-#{factor.month}"] = factor.factor
      result
    end
  end

  def allowance_in_year(year = Date.current.year)
    self.employee_allowances.find_by(year: year)
  end

  def holiday_remaining_in_year(year = Date.current.year)
    holidays = self.holidays_between(Date.new(year, 1, 1), Date.new(year, 12, 31))
    num_days = self._calculate_absence_days(holidays)
    allowance = self.allowance_in_year(year)
    unless allowance
      raise "No allowance found for year #{year} for #{self.name}"
    end
    allowance.holiday_allowance - num_days
  end
  private

  def _calculate_absence_days(absences)
    absences.reduce(0) do |result, absence|
      absence.half_day ? result + 0.5 : result + 1
    end
  end
end
