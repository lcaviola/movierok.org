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
    expire_page rip_path(rip)
    expire_fragment("rips/fragments/#{rip.id}")
  end
  
end
