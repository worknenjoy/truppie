Rails.application.routes.draw do
  
  resources :collaborators
  resources :customers
  resources :tour_pictures
  resources :bank_accounts do
    member do
      get 'activate', to: 'bank_accounts#activate', as: 'activate'
    end
  end
  resources :marketplaces do
    member do
      get 'activate', to: 'marketplaces#activate', as: 'activate'
      get 'update_account', to: 'marketplaces#update_account', as: 'update_account'
    end
  end
  resources :translations
  
  resources :packages
  
  get 'tags/index'
  get 'languages/index'
  get 'wheres/index'

  get 'contacts/index'  
  post 'contacts/send_form'
  
  get 'welcome/organizer', to: 'welcome#organizer', as: 'organizer_welcome'
  get 'welcome/user', to: 'welcome#user', as: 'user_welcome'

  resources :orders
  
  post 'webhook', to: 'orders#webhook'
  get 'new_webhook', to: 'orders#new_webhook'
  
  resources :organizers do
    member do
      get 'manage/(:tour)', to: 'organizers#manage', as: 'manage'
      get 'marketplace', to: 'organizers#marketplace', as: 'marketplace'
      get 'transfer', to: 'organizers#transfer', as: 'transfer'
      post 'transfer_funds', to: 'organizers#transfer_funds', as: 'transfer_funds'
      get 'tos_acceptance', to: 'organizers#tos_acceptance', as: 'tos_acceptance'
      post 'tos_acceptance_confirm', to: 'organizers#tos_acceptance_confirm', as: 'tos_acceptance_confirm'
      get 'dashboard', to: 'organizers#dashboard', as: 'dashboard'
      get 'confirm_account', to: 'organizers#confirm_account', as: 'confirm_account'
      get 'guided_tour', to: 'organizers#guided_tour', as: 'guided_tour'
      get 'edit_guided_tour/(:tour)', to: 'organizers#edit_guided_tour', as: 'edit_guided_tour'
    end
  end
  
  resources :tours do
    member do
      get 'confirm/(:packagename)', to: 'tours#confirm', as: 'confirm'
      post 'confirm_presence'
      get 'confirm_presence_alt'
      post 'unconfirm_presence'
    end
  end
  
  post 'subscribers/create'
  
  devise_for :users, :controllers => { 
    :registrations => "users/registrations",
    :omniauth_callbacks => "users/omniauth_callbacks"
  }
  
  #devise_scope :user do
  #  get 'orders_from_user', :to => 'devise/sessions#orders_from_user', :as => :orders_from_user
  #end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  
  get 'logos' => 'welcome#logos'
  get 'manifest' => 'welcome#manifest'
  get 'how_it_works' => 'welcome#how_it_works'
  get 'privacy' => 'welcome#privacy'
  get 'defs' => 'welcome#defs'
  get 'faq' => 'welcome#faq'
  
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
