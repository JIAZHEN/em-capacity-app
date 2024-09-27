# frozen_string_literal: true

class BankHoliday < ApplicationRecord
  before_save :set_year

  private

  def set_year
    self.year = calendar_date.year
  end
end
