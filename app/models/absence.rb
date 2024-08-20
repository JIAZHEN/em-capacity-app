class Absence < ApplicationRecord
  belongs_to :employee

  enum absence_type: { holiday: 0, sick_leave: 1 }
end
