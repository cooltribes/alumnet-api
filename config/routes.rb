Rails.application.routes.draw do

  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.alumnet+json; version=1"}) do
  end
end
