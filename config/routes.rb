require 'sidekiq/web'

Rails.application.routes.draw do

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production? || Rails.env.staging?

  mount Sidekiq::Web => '/sidekiq'

  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.alumnet+json;version=1"}) do

    post '/sign_in', to: 'auth#sign_in', as: :sign_in
    post '/oauth_sign_in', to: 'auth#oauth_sign_in', as: :oauth_sign_in
    post '/register', to: 'auth#register', as: :register
    post '/oauth_register', to: 'auth#oauth_register', as: :oauth_register

    resources :password_resets, only: [:create, :update]

    resource :me, only: [:show, :update], controller: 'me' do
      get :messages
      post :send_invitations
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
      resources :approval_requests, except: [:show], controller: 'me/approval' do
        put :notify_admins, on: :collection
      end

      post '/contacts/file', to: 'contacts#file' ###TEMPORAL
      post '/contacts/in_alumnet', to: 'contacts#in_alumnet' ###TEMPORAL
    end

    resources :users, except: :create do
      resource :profile, only: [:show, :update], controller: 'users/profiles'
      resources :posts, controller: 'users/posts'
      resources :events, controller: 'users/events'
      resources :albums, controller: 'users/albums'
      resources :memberships, except: :show, controller: 'users/memberships' do
        get :groups, on: :collection
      end
      resources :friendships, except: :show, controller: 'users/friendships' do
        get :friends, on: :collection
        get :commons, on: :collection
      end
      resources :subscriptions, except: :show, controller: 'users/subscriptions'
      resources :actions, except: :show, controller: 'users/actions'
    end

    resources :groups do
      post :cropping, on: :member
      post :add_group, on: :member
      get :subgroups, on: :member
      get :migrate_users, on: :member
      resources :posts, controller: 'groups/posts'
      resources :events, controller: 'groups/events'
      resources :memberships, except: :show, controller: 'groups/memberships' do
        get :members, on: :collection
      end
      resources :albums, controller: 'groups/albums'
    end

    resources :events do
      get :contacts, on: :member
      post :cropping, on: :member
      resources :posts, controller: 'events/posts'
      resources :albums, controller: 'events/albums'
      resources :payments, controller: 'events/payments'
    end

    resources :attendances

    resources :job_exchanges

    resources :actions

    resources :prizes

    resources :banners

    resources :pictures do
      post :like, on: :member
      post :unlike, on: :member
      resources :comments, controller: 'pictures/comments' do
        post :like, on: :member
        post :unlike, on: :member
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

    resources :albums do
      resources :pictures, controller: 'albums/pictures'
    end

    resources :countries, only: [:index, :show] do
      get :cities, on: :member
      get :committees, on: :member
    end

    resources :committees, only: [:index]

    resources :profiles, only: [:show, :update] do
      post :cropping, on: :member
      resources :experiences, except: [:new, :edit], controller: 'profiles/experiences'
      resources :skills, except: [:show, :new, :edit], controller: 'profiles/skills'
      resources :language_levels, except: [:show, :new, :edit], controller: 'profiles/language_levels'
      resources :contact_infos, except: [:show, :new, :edit], controller: 'profiles/contact_infos'
    end

    resources :languages, only: :index
    resources :skills, only: :index

    namespace :admin do
      resources :users, except: [:new, :edit] do
        put :activate, on: :member
        put :banned, on: :member
        put :change_role, on: :member
        get :stats, on: :collection
      end
      resources :groups, except: [:new, :edit] do
        get :subgroups, on: :member
      end
      resources :regions

      namespace :deleted do
        resources :groups, only: [:index, :update, :destroy]
        resources :users, only: [:index, :update, :destroy]
      end
    end
  end
end
