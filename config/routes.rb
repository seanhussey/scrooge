Scrooge::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => 'dashboard#index'
  
  devise_for :users
  
  match 'dashboard/:action', :controller => 'dashboard', :via => :get
  match 'dashboard' => 'dashboard#index', :via => :get
  
  match '/user_activities/stats/:year/:month' => 'user_activities#stats', :via => :get
  match '/user_activities/:user/:year/:month' => 'user_activities#index', :via => :get
  match '/user_activities/index' => 'user_activities#index', :via => :post
  match '/job_order_activities/:id' => 'job_order_activities#show', :via => :get

  match '/settings' => 'settings#index', :via => :get
  match '/settings/update' => 'settings#update', :via => :post
  match '/user_activity_types' => 'user_activity_types#index', :via => :get

  resources :weekly_activities do
    get 'current_week', :on => :collection, :action => 'get_current_week'
  end

  resources :activities_tracker do
    get 'today', :on => :collection, :action => 'today'
  end

  resources :expenses do
    post 'filter', :on => :collection, :action => 'filter'
  end

  resources :drop_box
  resources :invoices do
    get 'activate'
    get 'drop_box'
    get 'clone'
  end
  resources :inbound_invoices
  resources :job_orders do
    get 'activities'
    resources :job_order_activities
  end

  resources :user_activities do
    get 'report', :on => :collection, :action => 'report'
    get 'report_2', :on => :collection, :action => 'report_2'
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
