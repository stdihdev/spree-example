require 'sidekiq/web'
require 'sidekiq-status/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/'

  authenticate :spree_user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  scope module: :nelou do
    match '/globalsign', to: proc { [200, {}, ['125hxH ']] }, via: :get
    match '/404', to: 'errors#not_found', via: :all

    get '/designers', to: 'designer_labels#index', as: :nelou_designer_labels
    get '/designer/:id', to: 'designer_labels#show', as: :nelou_designer_label

    get '/designer_registration', to: 'designers#new', as: :new_designer
    post '/designer_registration', to: 'designers#create', as: :create_designer

    get '/help', to: 'pages#help', as: :help
    get '/imprint', to: 'pages#imprint', as: :imprint
    get '/privacy', to: 'pages#privacy', as: :privacy
    get '/terms-of-use', to: 'pages#terms_of_use', as: :terms_of_use

    post '/newsletter/unsubscribe', to: 'subscriptions#unsubscribe', as: :unsubscribe

    namespace :admin do
      get '/dashboard', to: 'dashboard#index', as: :dashboard
      get '/changelog', to: 'changelog#index', as: :changelog

      resources :designers, only: [ :index, :new, :create ], as: :nelou_designers
      resources :designer_labels, except: [ :show ], as: :nelou_designer_labels
      resources :wishlists, only: [ :index, :show ], as: :nelou_wishlists

      get '/orders_export', to: 'orders_export#index', as: :export_orders

      resources :size_option_types, except: [ :show ], as: :nelou_size_option_types do
        resources :size_option_values, only: [ :update ], as: :nelou_size_option_value
      end
      delete '/size_option_values/:id', to: 'size_option_values#destroy', as: :nelou_size_option_value
    end

    get '/admin/products/:product_id/sale', to: 'admin/sales#index', as: :admin_nelou_sales
    post '/admin/products/:product_id/sale', to: 'admin/sales#create'
    get '/admin/products/:product_id/sale/new', to: 'admin/sales#new', as: :new_admin_nelou_sale
    delete '/admin/products/:product_id/sale/cancel', to: 'admin/sales#cancel', as: :cancel_admin_nelou_sale
  end

  # Redirect for legacy routes
  get '/artikel-:id(/*ignored)', to: redirect('/products/%{id}?locale=de', status: 301), constraints: { id: /[0-9]+/ }
  get '/article-:id(/*ignored)', to: redirect('/products/%{id}?locale=en', status: 301), constraints: { id: /[0-9]+/ }
  get '/articulo-:id(/*ignored)', to: redirect('/products/%{id}?locale=en', status: 301), constraints: { id: /[0-9]+/ }

  get '/designerprofil/:slug', to: redirect('/designer/%{slug}?locale=de', status: 301), constraints: { id: /[0-9a-zA-Z\-]+/ }
  get '/label/:slug', to: redirect('/designer/%{slug}?locale=en', status: 301), constraints: { id: /[0-9a-zA-Z\-]+/ }
  get '/designerprofile/:slug', to: redirect('/designer/%{slug}?locale=en', status: 301), constraints: { id: /[0-9a-zA-Z\-]+/ }

  get '/de', to: redirect('/?locale=de', status: 301)
  get '/en', to: redirect('/?locale=en', status: 301)
end

Spree::Core::Engine.add_routes do
  get 'orders/:id/invoice' => 'orders#invoice', as: :order_invoice

  get '/new', to: 'taxons#recent', as: :recent_products
  get '/limit', to: 'taxons#limited', as: :limited_products
  get '/sale', to: 'taxons#on_sale', as: :sale_products
  get '/eco', to: 'taxons#eco', as: :eco_products

  get '/wished_products', to: 'wished_products#create'

  resources :products, :only => [:index, :show] do
    member do
      get 'images', defaults: {format: :json}
    end
  end
end
