Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "blogs#index"

  resources :admin, only: [:edit, :update, :destroy]

  post 'signup', to: 'authentication#signup'
  post 'signin', to: 'authentication#signin'
  post 'signout', to: 'authentication#signout'

  post 'blogs/search', to: 'blogs#search'
  get 'myblogs/draft', to: 'blogs#draft'
  get 'myblogs/archive', to: 'blogs#archive'
  get 'myblogs', to: 'blogs#shows'
  post 'blogs', to: 'blogs#create'
  get 'blogs', to:'blogs#index'
  get 'blogs/:id', to: 'blogs#show'
  delete 'blogs/:id', to:'blogs#destroy'
  post 'blogs/:id', to:'blogs#update'
  get 'blogs/:id/comments', to:'blogs#comment'
  get 'blogs/like/count', to: 'likes#count'
  get 'blogs/user/:id', to: 'blogs#getAuthorBlogs'
  post 'likes', to: 'likes#create'
  post 'likes/:id', to: 'likes#destroy'
 
  get 'home/admin', to: 'admin#admin'

  get 'comments/:id', to: 'comments#show'
  post 'comments/all', to: 'comments#index'
  post 'comments', to: 'comments#create'
  put 'comments/:id', to: 'comments#update'
  post 'comments/:id', to: 'comments#destroy'

end
