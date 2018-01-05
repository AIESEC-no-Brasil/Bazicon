Myapp::Application.routes.draw do
  devise_for :users

  root 'digital_transformation#expa_sign_up', programa: 'GV'
  post '/api/v1/pagarme/postback/:payment_id' => 'api/v1/pagarme/postback#update_status'

  # Digital Transformation
  get '/dt/difficulties'          => 'digital_transformation#difficulties',          as: 'digital_transformation_difficulties'
  get '/dt/prevents'              => 'digital_transformation#prevents',              as: 'digital_transformation_prevents'
  get '/dt/igcdp_interested'      => 'digital_transformation#igcdp_interested',      as: 'digital_transformation_igcdp_interested'
  get '/dt/igip_interested'       => 'digital_transformation#igip_interested',       as: 'digital_transformation_igip_interested'
  get '/expa/sign_up'             => 'digital_transformation#expa_sign_up',          as: 'expa_sign_up'
  post '/dt/difficulties_success' => 'digital_transformation#difficulties_success',  as: 'digital_transformation_difficulties_success'
  post '/dt/prevents_success'     => 'digital_transformation#prevents_success',      as: 'digital_transformation_prevents_success'
  post '/expa/sign_up'            => 'digital_transformation#expa_sign_up_success2', as: 'expa_sign_up_success'

  resources :payments, except: [ :edit, :update ]
end
