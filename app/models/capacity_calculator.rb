require_relative '../../lib/constants'

class CapacityCalculator
  attr_reader :months, :bank_holidays, :business_days

  def initialize(bank_holidays)
    @bank_holidays = bank_holidays
    self.get_monthly_business_days()
  end

  def get_monthly_business_days()
    the_year = Date.current.year
    @business_days ||= (1..12).reduce({}) do |result, month|
      start_date = Date.new(the_year, month, 1)
      end_date = start_date.end_of_month
      dates = self.business_days_between(start_date, end_date)
      month_name = MONTH_NAMES[month - 1]
      result[month_name] = dates.size
      result
    end
  end

  def business_days_in_month(month_name)
    business_days = get_monthly_business_days()
    business_days[month_name]
  end

  def get_employee_business_days(employee, month_name)
    month_number = self.get_month_number_from(month_name)
    business_days_in_month(month_name) - employee.absence_days_in_month(month_number)
  end

  def get_employee_engineering_days(employee, month_name)
    pure_business_days = get_employee_business_days(employee, month_name)
    month_number = self.get_month_number_from(month_name)
    engineering_factor = employee.engineering_factor_in_month(month_number)
    unless engineering_factor
      raise "No engineering factor found for #{employee.name} in #{month_name}"
    end

    pure_business_days * engineering_factor
  end

  def get_employee_engineering_days_between(employee, start_date, end_date)
    employee_factors = employee.engineering_factors_between(start_date, end_date)
    absences = employee.absences_between(start_date, end_date)

    (start_date..end_date).reduce(0) do |result, d|
      return result unless business_day?(d)
      factor = employee_factors["#{d.year}-#{d.month}"]
      unless factor
        raise "No engineering factor found for #{employee.name} in #{d.year}-#{d.month}}"
      end

      found_absence = absences.find { |absence| absence.calendar_date == d }
      day = found_absence ? (found_absence.half_day ? 0.5 : 0) : 1
      result + factor * day
    end
  end

  def get_month_number_from(month_name)
    MONTH_NAMES.find_index(month_name) + 1
  end

  # employees_engineering_days is an array of monthly employee's engineering days
  # it's an array of size 13
  # the first element is the employee's name
  # the rest of the elements are the engineering days for each month
  # Like: ["John Doe", 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20]
  def get_monthly_stats(employees_engineering_days)
    names, *months = employees_engineering_days.transpose
    monthly_totals = months.map(&:sum)
    running_sum = 0
    running_total = monthly_totals.map { |monthly_total| running_sum += monthly_total }
    { 
      "Monthly Total" => monthly_totals, 
      "Running Total" => running_total,
      "H1 Total" => monthly_totals.slice(0, 6).sum,
      "H2 Total" => monthly_totals.slice(6, 6).sum
    }
  end

  private

  def business_day?(date)
    working_day?(date) && !self.bank_holidays.include?(date)
  end

  def working_day?(date)
    !date.saturday? && !date.sunday?
  end

  def business_days_between(start_date, end_date)
    (start_date..end_date).filter {|d| business_day?(d) }
  end
end
