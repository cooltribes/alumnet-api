Rails.application.routes.draw do

  api_version(:module => "V1", :header => {:name => "Accept", :value => "json; version=1"}) do
    resources :users
  end
end
