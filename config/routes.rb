Sirocco::Application.routes.draw do

  resources :users do
    member do
      get :accounts
    end
  end

  resources :sessions, :only => [:new, :create, :destroy]

  resources :accounts do
    member do
      get :team_members
      get :projects
    end
  end  
  
  resources :sponsorships

  resources :projects do
    member do
      get :team_members
    end
  end  
  
  resources :memberships, :only => [:update]

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


  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  root :to => "pages#front"

end
