Rails.application.routes.draw do

  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.alumnet+json;version=1"}) do

    post '/sign_in', to: 'auth#sign_in', as: :sign_in

    resources :users do
      post :invite, on: :member
      resources :posts, controller: 'users/posts'
    end

    resources :groups do
      post :add_group, on: :member
      resources :posts, controller: 'groups/posts'
    end
  end
end
