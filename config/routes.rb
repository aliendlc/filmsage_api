Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    post '/users', to: 'users#create'
    post '/photos', to: 'photos#create'
    get  '/photos', to: 'photos#index'
    put '/photos/:id', to: 'photos#update'
    delete '/photos/:id', to: 'photos#delete'
end
