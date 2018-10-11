Rails.application.routes.draw do
  resources :addresses do
    collection do
      get :search
    end
  end

  resources :phone_numbers do
    collection do
      get :search
    end
  end

  resources :plants do
    collection do
      get :search
    end
  end

  resources :service_levels
  resources :service_records, only: []
  resources :sessions, only: [:create, :destroy]
  resources :user_roles, only: [:index]


  resources :users do
    member do
      patch :disable
      patch :enable
      patch :resend_invite
    end
    collection do
      post :invite
      post :invite_signup
      post :update_password
      post :send_password_reset
    end
  end
end
