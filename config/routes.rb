Rails.application.routes.draw do
  resources :messages, only: [:index, :create], :defaults => { :format => :json }
  resources :chats, only: [:index], :defaults => { :format => :json }
end
