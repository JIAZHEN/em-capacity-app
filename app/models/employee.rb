# frozen_string_literal: true

class Employee < ApplicationRecord
  has_many :employee_factors
  has_many :absences
  has_many :employee_allowances

  def absences_between(start_date, end_date)
    absences.where(calendar_date: start_date..end_date)
  end

  def holidays_between(start_date, end_date)
    absences.where(calendar_date: start_date..end_date, absence_type: Absence.absence_types[:holiday])
  end

  def absence_days_between(start_date, end_date)
    absences = absences_between(start_date, end_date)
    _calculate_absence_days(absences)
  end

  def engineering_factors_between(start_date, end_date)
    factors = employee_factors
              .where("TO_DATE('' || year || month, 'YYYYMM') >= ?", start_date.beginning_of_month)
              .where("TO_DATE('' || year || month, 'YYYYMM') <= ?", end_date.end_of_month)

    factors.each_with_object({}) do |factor, result|
      result["#{factor.year}-#{factor.month}"] = factor.factor
    end
  end

  def allowance_in_year(year = Date.current.year)
    employee_allowances.find_by(year:)
  end

  def holiday_remaining_in_year(year = Date.current.year)
    holidays = holidays_between(Date.new(year, 1, 1), Date.new(year, 12, 31))
    num_days = _calculate_absence_days(holidays)
    allowance = allowance_in_year(year)
    raise "No allowance found for year #{year} for #{name}" unless allowance

    allowance.holiday_allowance - num_days
  end

  private

  def _calculate_absence_days(absences)
    absences.reduce(0) do |result, absence|
      absence.half_day ? result + 0.5 : result + 1
    end
  end
end
