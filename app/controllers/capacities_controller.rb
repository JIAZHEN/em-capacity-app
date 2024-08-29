require_relative '../../lib/constants'

class CapacitiesController < ApplicationController
  def show
    the_year = Date.current.year
    @current_month = Date.current.month
    @month_names = MONTH_NAMES
    @bank_holidays = BankHoliday.where(year: the_year).map(&:calendar_date)
    @employees = Employee.includes(:employee_factors, :employee_allowances, :absences).all
    capacity_calculator = CapacityCalculator.new(@bank_holidays)

    dates = (1..12).map do |month|
      start_date = Date.new(the_year, month, 1)
      [start_date, start_date.end_of_month] 
    end

    @employees_engineering_days = []
    @holiday_remainings = 0
    @employees.map do |employee|
      employee_engineering_days = [employee.name]
      dates.each do |start_date, end_date|
        engineering_days = capacity_calculator.get_employee_engineering_days_between(employee, start_date, end_date)
        employee_engineering_days << engineering_days
      end
      
      @holiday_remainings += employee.holiday_remaining_in_year(the_year)
      @employees_engineering_days << employee_engineering_days
    end

    @monthly_stats = capacity_calculator.get_monthly_stats(@employees_engineering_days)
    @remaining_engineering_days = @monthly_stats["Monthly Total"].slice(@current_month..-1).sum
    @employees_engineering_days << ["Monthly Total", *@monthly_stats["Monthly Total"]]
    @employees_engineering_days << ["Running Total", *@monthly_stats["Running Total"]]
  end
end
