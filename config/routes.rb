Myapp::Application.routes.draw do

  # You can have the root of your site routed with 'root'
  root 'sessions#index'
  # All routes
  get '/'       => 'sessions#index',  as: 'index'
  get '/logout' => 'sessions#logout', as: 'logout'
  post '/login' => 'sessions#login',  as: 'login'

  # Archives
  get '/main'          => 'main#index',    as: 'main'
  get '/main/archives' => 'archives#show', as: 'archives_show'

  # Digital Transformation

  get '/dt/difficulties'          => 'digital_transformation#difficulties',         as: 'digital_transformation_difficulties'
  get '/dt/prevents'              => 'digital_transformation#prevents',             as: 'digital_transformation_prevents'
  get '/expa/sign_up'             => 'digital_transformation#expa_sign_up',         as: 'expa_sign_up'
  post '/dt/difficulties_success' => 'digital_transformation#difficulties_success', as: 'digital_transformation_difficulties_success'
  post '/dt/prevents_success'     => 'digital_transformation#prevents_success',     as: 'digital_transformation_prevents_success'
  post '/expa/sign_up'            => 'digital_transformation#expa_sign_up_success', as: 'expa_sign_up_success'


  get 'lc/dash'
  get 'lc/host'
  get 'lc/ogx'
  get 'lc/tm'

  get '/hosts/index'
  get 'files/index'
end

