Rails.application.routes.draw do
  namespace :admin do
    resources :absences
    resources :bank_holidays
    resources :employees
    resources :employee_factors
    resources :employee_allowances

    root to: 'employees#index'
  end

  get 'capacities/show'
  root to: 'capacities#show'
end
