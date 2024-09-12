Rails.application.routes.draw do
  
  resources :students do
    member do
      get :download, to: "students#download"
    end
  end

end
