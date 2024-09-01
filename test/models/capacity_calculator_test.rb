require "test_helper"

class CapacityCalculatorTest < ActiveSupport::TestCase
  setup do
    @bank_holidays = [Date.new(2024, 1, 1)]
    @start_date = Date.new(2024, 1, 1)
    @end_date = Date.new(2024, 1, 31)
  end

  test "get_employee_engineering_days_between returns right value in 2024 without any bank holidays" do
    calculator = CapacityCalculator.new([])
    employee = Employee.new
    engineering_days = calculator.get_employee_engineering_days_between(employee, @start_date, @end_date)
    assert_equal 23, engineering_days
  end

  test "get_employee_engineering_days_between returns right value in 2024 with new year bank holiday" do
    calculator = CapacityCalculator.new(@bank_holidays)
    employee = Employee.new
    engineering_days = calculator.get_employee_engineering_days_between(employee, @start_date, @end_date)
    assert_equal 22, engineering_days
  end

  test "get_employee_engineering_days_between returns right value in 2024 with bank holiday and absence" do
    # in fixture this employee has 2 days absence in January 2024
    employee = employees(:one)
    calculator = CapacityCalculator.new(@bank_holidays)
    engineering_days = calculator.get_employee_engineering_days_between(employee, @start_date, @end_date)
    assert_equal 20.0, engineering_days
  end

  test "get_employee_engineering_days_between returns right value in 2024 with bank holiday and absence with factor 0.5" do
    # in fixture this employee has 1 day absence and two half-days in January 2024
    employee = employees(:one)
    EmployeeFactor.create!(employee: employee, factor: 0.5, month: 1, year: 2024)
    calculator = CapacityCalculator.new(@bank_holidays)
    engineering_days = calculator.get_employee_engineering_days_between(employee, @start_date, @end_date)
    assert_equal 10.5, engineering_days
  end
end
