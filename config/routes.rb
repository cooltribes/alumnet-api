Rails.application.routes.draw do

  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.alumnet+json;version=1"}) do

    post '/sign_in', to: 'auth#sign_in', as: :sign_in
    post '/register', to: 'auth#register', as: :register

    resources :password_resets, only: [:create, :update]

    resource :me, only: [:show, :update], controller: 'me' do
      get :messages
      resource :profile, only: [:show, :update], controller: 'me/profiles'
      resources :posts, controller: 'me/posts'
      resources :friendships, except: :show, controller: 'me/friendships' do
        get :friends, on: :collection
      end
      resources :conversations, except: [:new, :edit, :update], controller: 'me/conversations' do
        resources :receipts, only: [:index, :show, :create], controller: 'me/receipts' do
          put :read, on: :member
          put :unread, on: :member
        end
      end
      resources :notifications, only: [:index, :destroy], controller: 'me/notifications' do
        put :mark_all_read, on: :collection
        put :mark_as_read, on: :member
        put :mark_as_unread, on: :member
      end
      resources :privacies, except: :show, controller: 'me/privacies'
    end

    resources :users, except: :create do
      resource :profile, only: [:show, :update], controller: 'users/profiles'
      resources :posts, controller: 'users/posts'
      resources :memberships, except: :show, controller: 'users/memberships' do
        get :groups, on: :collection
      end
      resources :friendships, except: :show, controller: 'users/friendships' do
        get :friends, on: :collection
        get :commons, on: :collection
      end
    end

    resources :groups do
      post :add_group, on: :member
      get :subgroups, on: :member
      resources :posts, controller: 'groups/posts'
      resources :memberships, except: :show, controller: 'groups/memberships' do
        get :members, on: :collection
      end
    end

    resources :posts, only: :show do
      post :like, on: :member
      post :unlike, on: :member
      resources :comments, controller: 'posts/comments' do
        post :like, on: :member
        post :unlike, on: :member
      end
    end

    resources :regions, only: [:index, :show]

    resources :countries, only: [:index, :show] do
      get :cities, on: :member
      get :committees, on: :member
    end

    resources :committees, only: [:index]

    resources :profiles, only: [:show, :update] do
      resources :experiences, except: [:new, :edit], controller: 'profiles/experiences'
      # resources :experiences, except: [:show, :new, :edit], controller: 'profiles/experiences'
      resources :skills, except: [:show, :new, :edit], controller: 'profiles/skills'
      resources :language_levels, except: [:show, :new, :edit], controller: 'profiles/language_levels'
      resources :contact_infos, except: [:show, :new, :edit], controller: 'profiles/contact_infos'
    end

    resources :languages, only: :index
    resources :skills, only: :index

    namespace :admin do
      resources :users, except: [:new, :edit] do
        put :activate, on: :member
        put :inactivate, on: :member
        put :change_role, on: :member
      end
      resources :groups, except: [:new, :edit] do
        get :subgroups, on: :member
      end

      namespace :deleted do
        resources :groups, only: [:index, :update, :destroy]
        resources :users, only: [:index, :update, :destroy]
      end
    end
  end
end
