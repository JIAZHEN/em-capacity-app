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

      dates = (start_date..end_date).filter {|d| self.business_day?(d) }
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

  private

  def get_month_number_from(month_name)
    MONTH_NAMES.find_index(month_name) + 1
  end

  def business_day?(date)
    working_day?(date) && !self.bank_holidays.include?(date)
  end

  def working_day?(date)
    !date.saturday? && !date.sunday?
  end
end
