require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  test 'absence_days_between returns 0 in no holiday period' do
    employee = employees(:one)
    days = employee.absence_days_between(Date.new(2021, 1, 1), Date.new(2021, 1, 31))
    assert_equal 0, days
  end

  test 'absence_days_between returns 2 in 2024 Jan as fixture setup' do
    employee = employees(:one)
    days = employee.absence_days_between(Date.new(2024, 1, 1), Date.new(2024, 1, 31))
    assert_equal 2.0, days
  end

  test 'engineering_factors_between returns empty if not found' do
    employee = employees(:one)
    factors = employee.engineering_factors_between(Date.new(2024, 1, 1), Date.new(2024, 1, 31))
    assert_equal({}, factors)
  end

  test 'engineering_factors_between returns map if found' do
    employee = employees(:one)
    factors = employee.engineering_factors_between(Date.new(2014, 1, 1), Date.new(2014, 3, 31))
    assert_equal({ '2014-1' => 1.5 }, factors)
  end

  test 'allowance_in_year returns nil if no allowance found' do
    employee = employees(:one)
    allowance = employee.allowance_in_year(2022)
    assert_nil allowance
  end

  test 'allowance_in_year returns 30 if allowance is found' do
    employee = employees(:one)
    allowance = employee.allowance_in_year(2024)
    assert_equal 30, allowance.holiday_allowance
    assert_equal 5, allowance.sick_leave_allowance
  end

  test 'holiday_remaining_in_year returns right result when person has 1.5 out of 30 holidays' do
    employee = employees(:one)
    days = employee.holiday_remaining_in_year(2024)
    assert_equal 28.5, days
  end
end
