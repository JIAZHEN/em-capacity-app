# frozen_string_literal: true

class EmployeeFactor < ApplicationRecord
  belongs_to :employee

  class << self
    def create_yearly_factors(employee, year, factors)
      raise ArgumentError, 'Factors must be provided for all 12 months' if factors.size != 12

      (1..12).zip(factors).each do |pair|
        month_number, factor = pair
        EmployeeFactor.create(employee:, year:, month: month_number, factor:)
      end
    end
  end
end
