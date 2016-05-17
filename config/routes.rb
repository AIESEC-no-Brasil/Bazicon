Myapp::Application.routes.draw do

  # You can have the root of your site routed with 'root'
  root 'sessions#index'

  get '/admin/force_update' => 'main#force_update', as: 'force_update'
  # All routes
  get '/'       => 'sessions#index',  as: 'index'
  get '/logout' => 'sessions#logout', as: 'logout'
  post '/login' => 'sessions#login',  as: 'login'

  # Archives
  get '/main'          => 'main#index',    as: 'main'
  get '/main/archives' => 'archives#show', as: 'archives_show'
  get '/main/archives/edit/:id' => 'archives#edit', as: 'archives_edit'
  get '/main/archives/download/:id' => 'archives#download', as: 'archives_download'
  post 'restore_archive' => 'archives#restore_archive', as: 'restore_archive'
  post 'upload'        => 'archives#upload', as: 'upload'
  post  '/main/archives/remove' =>'archives#remove', as: 'remove'
  post  'update' =>'archives#update', as: 'update'
  post  '/archives/retrieve_selected_tags' =>'archives#retrieve_selected_tags'
  post '/main/archives' => 'archives#show', as: 'post_archives_show'



  # Digital Transformation
  get '/dt/difficulties'          => 'digital_transformation#difficulties',         as: 'digital_transformation_difficulties'
  get '/dt/prevents'              => 'digital_transformation#prevents',             as: 'digital_transformation_prevents'
  get '/dt/igcdp_interested'      => 'digital_transformation#igcdp_interested',     as: 'digital_transformation_igcdp_interested'
  get '/dt/igip_interested'      => 'digital_transformation#igip_interested',       as: 'digital_transformation_igip_interested'
  get '/expa/sign_up'             => 'digital_transformation#expa_sign_up',         as: 'expa_sign_up'
  post '/dt/difficulties_success' => 'digital_transformation#difficulties_success', as: 'digital_transformation_difficulties_success'
  post '/dt/prevents_success'     => 'digital_transformation#prevents_success',     as: 'digital_transformation_prevents_success'
  post '/expa/sign_up'            => 'digital_transformation#expa_sign_up_success', as: 'expa_sign_up_success'

  # Outgoing Exchange
  get '/ogx/dash'   => 'outgoing_exchange#dash',   as: 'outgoing_exchange_dash'
  get '/ogx/list'   => 'outgoing_exchange#list',   as: 'outgoing_exchange_list'
  get '/ogx/detail' => 'outgoing_exchange#detail', as: 'outgoing_exchange_detail'
  post '/ogx/dash'  => 'outgoing_exchange#dash',   as: 'outgoing_exchange_dash_form'
  post '/ogx/list'  => 'outgoing_exchange#list',   as: 'outgoing_exchange_list_form'

  get 'lc/dash'
  get 'lc/host'
  get 'lc/ogx'
  get 'lc/tm'

  get '/hosts/index'
  get 'files/index'


end
