Rails.application.routes.draw do
  # resources :tasks
  resources :tasks, defaults: {format: JSON}
  get 'home/index'
end
