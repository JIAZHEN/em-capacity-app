# frozen_string_literal: true

class CapacitiesController < ApplicationController
  JAN = :jan
  FEB = :feb
  MAR = :mar
  APR = :apr
  MAY = :may
  JUN = :jun
  JUL = :jul
  AUG = :aug
  SEP = :sep
  OCT = :oct
  NOV = :nov
  DEC = :dec
  MONTH_NAMES = [JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC].freeze

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

    # dynamic table
    @dynamic_start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
    @dynamic_end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current.end_of_year
    @dynamic_team = params[:team]&.downcase 
    @dynamic_employees_engineering_days = []
    @employees.each do |employee|
      next if @dynamic_team.present? && employee.team.downcase != @dynamic_team

      employee_engineering_days = [employee.name]
      engineering_days = capacity_calculator.get_employee_engineering_days_between(employee, @dynamic_start_date,
                                                                                   @dynamic_end_date)
      holiday_remaining = employee.holiday_remaining_in_year(the_year)
      employee_engineering_days << engineering_days
      employee_engineering_days << holiday_remaining
      employee_engineering_days << (engineering_days - holiday_remaining)
      @dynamic_employees_engineering_days << employee_engineering_days
    end
    @dynamic_stats = capacity_calculator.get_stats(@dynamic_employees_engineering_days)
    @remaining_engineering_days = @dynamic_stats[:column_totals][0] || 0
  end
end
