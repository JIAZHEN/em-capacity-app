require_relative '../../lib/constants'

class CapacitiesController < ApplicationController
  def show
    @month_names = MONTH_NAMES
    @bank_holidays = BankHoliday.where(year: Date.current.year)
  end
end
