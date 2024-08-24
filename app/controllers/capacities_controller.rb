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
      employee_total = 0
      @month_names.map do |month_name|
        engineering_days = capacity_calculator.get_employee_engineering_days(employee, month_name)
        employee_total += engineering_days
        employee_engineering_days << engineering_days
      end
      employee_engineering_days << employee_total
      @employees_engineering_days << employee_engineering_days
    end
  end
end
