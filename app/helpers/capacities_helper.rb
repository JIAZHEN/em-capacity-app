module CapacitiesHelper
  def get_column_colour(current_month, index)
    index == current_month ? "dark:bg-gray-800" : ""
  end

  # ["John Doe", 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20]
  def get_employee_series(headers, dynamic_employees_engineering_days)
    dynamic_employees_engineering_days.map do |engineering_days|
      {
        name: engineering_days[0],
        data: headers.zip(engineering_days.drop(1))
      }
    end
  end
end
