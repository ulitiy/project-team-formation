Ptf1::Application.routes.draw do
  #пути для аутентификации/регистрации
  devise_for :accounts, :path_names => {
    :sign_up => :register, :sign_in => :login, :sign_out => :logout
  }
  #пути для ресурсов
  resources :people do
    resources :cwl_people
  end

  resources :competences
  resources :tasks do
    resources :cwl_tasks
  end
  resources :projects do
    resources :tasks
  end
  #главная страница
  root :to => "projects#index"
end

