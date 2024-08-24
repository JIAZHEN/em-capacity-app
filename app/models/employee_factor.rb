class EmployeeFactor < ApplicationRecord
  belongs_to :employee

  class << self
    def create_yearly_factors(employee, year, factors)
      if factors.size != 12
        raise "Factors must be provided for all 12 months"
      end

      (1..12).zip(factors).each do |pair|
        month_number, factor = pair
        EmployeeFactor.create(employee: employee, year: year, month: month_number, factor: factor)
      end
    end
  end
end
