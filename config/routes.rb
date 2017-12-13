Rails.application.routes.draw do
  post '/shorten', to: 'short#create'
  get '/:shortcode', to: 'short#show'
  get '/:shortcode/stats', to: 'short#stat'
end
