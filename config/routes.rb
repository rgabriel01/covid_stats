Rails.application.routes.draw do
  resources :covid_observations
  match '/top/:statistic', to: 'covid_observations#top', as: :top_statistics, via: [:get]
  root 'covid_observations#index'
end
