# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :polls do
  collection do
    get 'report'
    post 'report', action: 'poll_answers'
  end
  member do
    post 'vote', action: 'vote'
  end
end
