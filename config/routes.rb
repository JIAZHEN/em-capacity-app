Rails.application.routes.draw do
  get 'capacities/show'
  namespace :admin do
    resources :absences
    resources :bank_holidays
    resources :employees
    resources :employee_factors

    root to: "absences#index"
  end
end
