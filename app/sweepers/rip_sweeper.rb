class RipSweeper < ActionController::Caching::Sweeper
  observe Rip
  
  def after_update(rip)
    clear_cache(rip)
  end
  
  def after_destroy(rip)
    clear_cache(rip)
  end
  
  def after_create(rip)
    clear_cache(rip)
  end
  
  def clear_cache(rip)
    RipSweeper.delete_ratings rip.users
    expire_cache_for_rips rip.movie.rips
  end
  
  ###
  def expire_cache_for_rips(rips)
    for rip in rips
      expire_cache_for_rip(rip)
    end
  end
  
  def expire_cache_for_rip(rip)
    expire_action rip_url(rip)
    expire_fragment("rips/fragments/#{rip.id}")
  end
  
  ###
    
  def self.delete_ratings(users = nil)
    path = RAILS_ROOT + '/tmp/cache/rips/ratings'
    if users
      for user in users
        self.delete_ratings(user)
      end
    else
      FileUtils.rm_r(path) if File.exists?(path)
    end
  end
  
  def self.delete_ratings(user)
    user_id = (user.instance_of? User) ? user.id : user
    path = RAILS_ROOT + '/tmp/cache/rips/ratings'
    file = "#{path}/#{user_id}.cache"
    File.delete(file) if File.exists?(file)
  end

end