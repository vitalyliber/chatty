Rails.application.routes.draw do
  resources :messages, only: [:index, :create], :defaults => { :format => :json } do
    collection do
      put :read
    end
  end
  resources :chats, only: [:index], :defaults => { :format => :json }
end
