Rails.application.routes.draw do

  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.alumnet+json;version=1"}) do

    post '/sign_in', to: 'auth#sign_in', as: :sign_in
    post '/register', to: 'auth#register', as: :register

    resources :users, except: :create do
      get :me, on: :collection
      post :invite, on: :member
      resource :profile, only: [:show, :update]
      resources :posts, controller: 'users/posts'
    end

    resources :groups do
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
