Rails.application.routes.draw do
  namespace :admin do
    resources :absences
    resources :bank_holidays
    resources :employees
    resources :employee_factors
  end

  get 'capacities/show'
  root to: "capacities#show"
end
