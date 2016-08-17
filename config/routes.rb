Rails.application.routes.draw do

  root to: 'landing#index'
  get :about, to: 'static_pages#about'
  post :upvote, to: 'votes#upvote'
  post :downvote, to: 'votes#downvote'

  resources :topics, except: [:show] do
    resources :posts, except: [:show] do
      resources :comments, except: [:show]
    end
  end
  resources :users, only: [:new, :edit, :create, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :edit, :create, :update]

  mount ActionCable.server => '/cable'



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
