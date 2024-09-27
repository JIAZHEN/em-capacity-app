# frozen_string_literal: true

require 'test_helper'

class EmployeeFactorTest < ActiveSupport::TestCase
  test '.create_yearly_factors raises error when array is not exact 12 size' do
    assert_raises(ArgumentError) do
      EmployeeFactor.create_yearly_factors(Employee.new, 2021, [1, 2, 3])
    end
  end

  test '.create_yearly_factors create right factors' do
    employee = Employee.create(name: 'John Doe')
    EmployeeFactor.create_yearly_factors(employee, 2021, [1] * 12)
    employee.reload
    assert_equal 12, employee.employee_factors.count
    assert_equal 1, employee.employee_factors.first.factor
  end
end
