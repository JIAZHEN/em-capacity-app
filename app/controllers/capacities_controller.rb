require_relative '../../lib/constants'

class CapacitiesController < ApplicationController
  def show
    @month_names = MONTH_NAMES
    @bank_holidays = BankHoliday.where(year: Date.current.year)
    @employees = Employee.includes(:employee_factors, :employee_allowances, :absences).all
    capacity_calculator = CapacityCalculator.new(@bank_holidays)

    @employees_engineering_days = []
    @employees.map do |employee|
      employee_engineering_days = [employee.name]
      @month_names.map do |month_name|
        engineering_days = capacity_calculator.get_employee_engineering_days(employee, month_name)
        # get the sum of the employee row
        month_index = capacity_calculator.get_month_number_from(month_name)
        employee_engineering_days << engineering_days
      end
      @employees_engineering_days << employee_engineering_days
    end

    @monthly_stats = capacity_calculator.get_monthly_stats(@employees_engineering_days)
    @employees_engineering_days << ["Monthly Total", *@monthly_stats["Monthly Total"]]
    @employees_engineering_days << ["Running Total", *@monthly_stats["Running Total"]]
  end
end
