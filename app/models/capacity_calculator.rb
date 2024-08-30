require_relative '../../lib/constants'

class CapacityCalculator
  attr_reader :months, :bank_holidays, :business_days

  def initialize(bank_holidays)
    @bank_holidays = bank_holidays
  end

  def get_employee_engineering_days_between(employee, start_date, end_date)
    employee_factors = employee.engineering_factors_between(start_date, end_date)
    absences = employee.absences_between(start_date, end_date)
    (start_date..end_date).reduce(0) do |result, d|
      if business_day?(d)
        factor = employee_factors["#{d.year}-#{d.month}"]
        unless factor
          raise "No engineering factor found for #{employee.name} in #{d.year}-#{d.month}}"
        end
        found_absence = absences.find { |absence| absence.calendar_date == d }
        day = found_absence ? (found_absence.half_day ? 0.5 : 0) : 1
        result += factor * day
      end

      result
    end
  end

  # employees_engineering_days is an array of monthly employee's engineering days
  # it's an array of size 13
  # the first element is the employee's name
  # the rest of the elements are the engineering days for each month
  # Like: ["John Doe", 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20]
  def get_stats(employees_engineering_days)
    names, *columns = employees_engineering_days.transpose
    column_totals = columns.map(&:sum)
    running_sum = 0
    running_total = column_totals.map { |column_total| running_sum += column_total }
    { column_totals: column_totals,  running_total: running_total }
  end

  private

  def business_day?(date)
    working_day?(date) && !self.bank_holidays.include?(date)
  end

  def working_day?(date)
    !date.saturday? && !date.sunday?
  end
end
