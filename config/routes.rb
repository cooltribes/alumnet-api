Rails.application.routes.draw do

  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.alumnet+json;version=1"}) do

    post '/sign_in', to: 'auth#sign_in', as: :sign_in
    post '/register', to: 'auth#register', as: :register

    get '/me', to: 'user#me', as: :me
    get '/me/profile', to: 'user#profile', as: :me_profile
    put '/me/profile', to: 'user#update_profile'

    resources :friendships, except: :show

    resources :users, except: :create do
      post :invite, on: :member
      resource :profile, only: [:show, :update]
      resources :posts, controller: 'users/posts'
      resources :friends, only: [:index], controller: 'users/friends'
    end

    resources :groups do
      get :members, on: :member
      post :join, on: :member
      post :add_group, on: :member
      resources :posts, controller: 'groups/posts'
    end

    resources :posts, only: :show do
      post :like, on: :member
      post :unlike, on: :member
      resources :comments, controller: 'posts/comments' do
        post :like, on: :member
        post :unlike, on: :member
      end
    end
  end
end
