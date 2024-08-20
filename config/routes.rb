Rails.application.routes.draw do
  namespace :admin do
      resources :absences
      resources :bank_holidays
      resources :employees
      resources :employee_factors

      root to: "absences#index"
    end
end
