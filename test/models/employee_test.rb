require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test "absence_days_between returns 0 in no holiday period" do
    employee = employees(:one)
    days = employee.absence_days_between(Date.new(2021, 1, 1), Date.new(2021, 1, 31))
    assert_equal 0, days
  end

  test "absence_days_between returns 2 in 2024 Jan as fixture setup" do
    employee = employees(:one)
    days = employee.absence_days_between(Date.new(2024, 1, 1), Date.new(2024, 1, 31))
    assert_equal 2.0, days
  end

  test "allowance_in_year returns nil if no allowance found" do
    employee = employees(:one)
    allowance = employee.allowance_in_year(2022)
    assert_nil allowance
  end
end
