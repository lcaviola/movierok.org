ActionController::Routing::Routes.draw do |map|

  map.resources :rips,
  :collection => {'covers' => :get, 'releasers' => :get},
  :member => {'versions' => :get, 'restore' => :put},
  :has_many => [:ratings, :comments]

  map.resources :parts,
  :collection => {'remove' => :put, 'incomplete' => :get, 'complete' => :put}

  # can you do this with has_many?
  map.resources :users do |user|
    user.resources :rips, :collection => {'covers' => :get, 'all' => :get}
  end

  map.resources :ratings

  map.login 'login', :controller => 'sessions', :action => 'create'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'

  map.root :controller => 'movierok'
  map.about 'about', :controller => 'movierok', :action => 'about'
  map.clients 'clients', :controller => 'movierok', :action => 'clients'
  map.lost_password 'lost_password', :controller => 'users', :action => 'lost_password'
  map.help 'help', :controller => 'movierok', :action => 'help'
  map.stats 'stats', :controller => 'movierok', :action => 'stats'
  map.ffextversion 'firefox_extension/compatible_versions.:format', :controller => 'movierok', :action => 'ffextversion'
  map.advanced_search 'advanced_search', :controller => 'movierok', :action => 'advanced_search'
  map.sitemap 'sitemap.:format', :controller => 'movierok', :action => 'sitemap'

  map.connect "logged_exceptions/:action/:id", :controller => "logged_exceptions"
end
