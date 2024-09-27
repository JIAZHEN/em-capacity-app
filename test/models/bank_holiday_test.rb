require 'test_helper'

class BankHolidayTest < ActiveSupport::TestCase
  test 'set year from calendar date' do
    holiday = BankHoliday.create(calendar_date: Date.new(2021, 1, 1))
    assert_equal 2021, holiday.year
  end
end
