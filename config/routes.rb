Myapp::Application.routes.draw do

  # You can have the root of your site routed with 'root'
  root 'sessions#index'

  # All routes
  get '/' => 'sessions#index', as: 'index'
  get '/logout' => 'sessions#logout', as: 'logout'
  post '/login' => 'sessions#login', as: 'login'

  get '/main' => 'main#index', as: 'main'
  get '/main/archives' => 'archives#show', as: 'archives_show'










  get 'lc/dash'
  get 'lc/host'
  get 'lc/ogx'
  get 'lc/tm'
  get 'files/index'
end