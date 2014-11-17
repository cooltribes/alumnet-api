Rails.application.routes.draw do

  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.alumnet+json;version=1"}) do

    post '/sign_in', to: 'auth#sign_in', as: :sign_in
    post '/register', to: 'auth#register', as: :register

    resource :me, only: [:show, :update], controller: 'me' do
      resource :profile, only: [:show, :update], controller: 'me/profiles'
      resources :friendships, except: :show, controller: 'me/friendships' do
        get :friends, on: :collection
      end
      # resources :groups, controller: 'user/groups'
    end

    resources :users, except: :create do
      resource :profile, only: [:show, :update]
      resources :posts, controller: 'users/posts'
      resources :memberships, except: :show, controller: 'users/memberships' do
        get :groups, on: :collection
      end
    end

    resources :groups do
      post :add_group, on: :member
      resources :memberships, except: :show, controller: 'groups/memberships' do
        get :members, on: :collection
      end
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

    resources :countries, only: [:index, :show] do
      get :cities, on: :member
    end
  end
end
