Rails.application.routes.draw do
  resources :covid_observations
  root 'covid_observations#index'
end
