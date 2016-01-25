require 'sidekiq/web'

Rails.application.routes.draw do

  Sidekiq::Web.use Rack::Session::Cookie, :secret => Rails.application.config.secret_token
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == Settings.sidekiq_password
  end if Rails.env.production? || Rails.env.staging?
  Sidekiq::Web.instance_eval { @middleware.reverse! }

  mount Sidekiq::Web => '/sidekiq'

  root 'home#index'
  get '/status', to: 'home#status'

  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.alumnet+json;version=1"}) do

    post '/sign_in', to: 'auth#sign_in', as: :sign_in
    post '/oauth_sign_in', to: 'auth#oauth_sign_in', as: :oauth_sign_in
    post '/register', to: 'auth#register', as: :register
    post '/oauth_register', to: 'auth#oauth_register', as: :oauth_register

    get '/public_profile/:slug', to: 'public_profiles#show'

    match '/search', to: 'search#search', via: [:post, :get]
    get '/suggestions', to: 'search#suggestions'

    resources :password_resets, only: [:create, :update]

    resource :me, only: [:show, :update], controller: 'me' do
      get :messages
      get :receptive_settings
      get :profinda_token
      post :send_invitations
      post :activate
      resource :profile, only: [:show, :update], controller: 'me/profiles'
      resource :registration, only: [:show, :update], controller: 'me/registration'
      resources :posts, controller: 'me/posts'

      resources :friendships, except: :show, controller: 'me/friendships' do
        get :friends, on: :collection
        get :suggestions, on: :collection
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
        get :friendship, on: :collection
        get :general, on: :collection
        put :mark_requests_all_read, on: :collection
      end
      resources :privacies, except: :show, controller: 'me/privacies'
      resources :approval_requests, except: [:show], controller: 'me/approval' do
        put :notify_admins, on: :collection
        get :approval_requests, on: :collection
      end

      resources :devices, only: [:index, :create], controller: 'me/devices'

      resources :groups, only: :index, controller: 'me/groups' do
        get :my_groups, on: :collection
      end


      post '/contacts/file', to: 'contacts#file' ###TEMPORAL
      post '/contacts/in_alumnet', to: 'contacts#in_alumnet' ###TEMPORAL

      get '/suggestions/groups', to: 'me/suggestions#groups'
      get '/suggestions/users', to: 'me/suggestions#users'
    end

    resources :users, except: :create do
      post :register_visit, on: :member
      resource :profile, only: [:show, :update], controller: 'users/profiles'
      resources :posts, controller: 'users/posts'
      resources :events, controller: 'users/events'
      resources :albums, controller: 'users/albums'
      resources :business, controller: 'users/business'

      resources :memberships, except: :show, controller: 'users/memberships' do
        get :groups, on: :collection
      end
      resources :friendships, except: :show, controller: 'users/friendships' do
        get :friends, on: :collection
        get :commons, on: :collection
      end
      resources :subscriptions, except: :show, controller: 'users/subscriptions'
      resources :actions, except: :show, controller: 'users/actions' do
        get :history, on: :collection
      end
      resources :prizes, except: :show, controller: 'users/prizes'
      resources :products, controller: 'users/products' do
        post :add_product, on: :member
      end
      resources :payments, except: :show, controller: 'users/payments'
      post :change_password, on: :member
      resources :email_preferences, controller: 'users/email_preferences'
    end

    resources :groups do
      post :picture, on: :member
      post :cropping, on: :member
      post :add_group, on: :member
      get :subgroups, on: :member
      get :migrate_users, on: :member
      get :validate_mailchimp, on: :member
      resources :posts, controller: 'groups/posts'
      resources :events, controller: 'groups/events'
      resources :memberships, except: :show, controller: 'groups/memberships' do
        get :members, on: :collection
      end
      resources :albums, controller: 'groups/albums'
      resources :folders, controller: 'groups/folders'
      resources :campaigns, controller: 'groups/campaigns' do
        post :send_test, on: :collection
        post :preview, on: :collection
      end
    end

    resources :events do
      post :picture, on: :member
      get :contacts, on: :member
      post :cropping, on: :member
      resources :posts, controller: 'events/posts'
      resources :albums, controller: 'events/albums'
      resources :payments, controller: 'events/payments'
      resources :folders, controller: 'events/folders'
    end

    resources :job_exchanges, :business_exchanges, :meetup_exchanges do
      get :my, on: :collection
      get :automatches, on: :collection
      get :applied, on: :collection
      get :matches, on: :member
      put :apply, on: :member
    end

    resources :task_invitations, except: :show

    resources :attendances

    resources :actions

    resources :seniorities, except: :show

    resources :features, except: :show do
      get :validate, on: :collection
    end

    resources :prizes

    resources :products do
      get :find_by_sku, on: :collection
    end

    resources :banners

    resources :keywords

    resources :tags, only: :index

    resources :contact, only: :create

    resources :companies do
      post :cropping, on: :member
      get :all, on: :collection
      get :employees, on: :member
      get :past_employees, on: :member
      get :admins, on: :member
      resources :branches, except: :show, controller: 'companies/branches'
      resources :contact_infos, except: :show, controller: 'companies/contact_infos'
      resources :product_services, except: :show, controller: 'companies/product_services'
      resources :company_admins, except: :show, controller: 'companies/company_admins'
      resources :links, except: :show, controller: 'companies/links'
    end

    resources :branches, only: :show do
      resources :contact_infos, except: :show, controller: 'branches/contact_infos'
    end

    resources :product_services, only: :index

    resources :business, only: [:index, :show] do
      resources :links, controller: 'business/links'
    end

    resources :folders, only: :show do
      resources :attachments, controller: 'folders/attachments'
    end

    resources :pictures do
      post :like, on: :member
      post :unlike, on: :member
      resources :comments, controller: 'pictures/comments' do
        post :like, on: :member
        post :unlike, on: :member
      end
      resources :user_tags, controller: 'pictures/user_tags', only: [:index, :create, :destroy]
    end

    resources :posts, only: :show do
      post :like, on: :member
      post :unlike, on: :member
      #get :get_tags, on: :member
      resources :comments, controller: 'posts/comments' do
        post :like, on: :member
        post :unlike, on: :member
      end
      resources :likes, controller: 'posts/likes', only: :index
    end

    resources :albums do
      resources :pictures, controller: 'albums/pictures'
    end

    resources :countries, only: [:index, :show] do
      get :cities, on: :member
      get :committees, on: :member
    end

    resources :cities, only: [:show]

    resources :committees, only: [:index]
    resources :sectors, only: [:index]

    resources :profiles, only: [:show, :update] do
      post :cropping, on: :member, on: :member
      resources :experiences, except: [:new, :edit], controller: 'profiles/experiences'
      resources :skills, except: [:show, :new, :edit, :update], controller: 'profiles/skills'
      resources :language_levels, except: [:show, :new, :edit], controller: 'profiles/language_levels'
      resources :contact_infos, except: [:show, :new, :edit], controller: 'profiles/contact_infos'
    end

    resources :languages, only: :index
    resources :skills, only: :index
    resources :payments
    resources :metatags, only: [:index]
    resources :tempfiles, only: [:index]

    namespace :admin do
      get 'stats/type_of_membership', to: 'stats#type_of_membership'
      get 'stats/country_and_region', to: 'stats#country_and_region'
      get 'stats/generation_and_gender', to: 'stats#generation_and_gender'
      get 'stats/seniorities', to: 'stats#seniorities'
      get 'stats/status', to: 'stats#status'
      get 'stats/posts', to: 'stats#posts_stats'
      resources :users, except: [:new, :edit] do
        ## TODO: Refactor this. Splint in new controllers
        member do
          get :groups
          get :events
          post :note
          put :activate
          put :banned
          put :change_role
          get :statistics
        end
        collection do
          post :register
          get :stats
          post :csv
        end
      end
      resources :groups, except: [:new, :edit] do
        get :subgroups, on: :member
      end
      resources :regions
      resources :campaigns, only: [:index, :show]

      namespace :deleted do
        resources :groups, only: [:index, :update, :destroy]
        resources :users, only: [:index, :update, :destroy]
      end
    end
  end
end
