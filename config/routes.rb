Rails.application.routes.draw do

  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.alumnet+json; version=1"}) do
    resources :users
    resources :groups do
      post :add_group, on: :member
    end
  end
end
