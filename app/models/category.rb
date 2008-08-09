class Category < ActiveRecord::Base
  acts_as_tree
  
  def genre_id
    return nil if parent.nil?
    p = self
    p = p.parent until p.parent.parent.nil?
    unless $genres.values.include? p.id
      logger.error "Warning: #{p.id} is an unkown genre id"
      return nil
    end
    p.id
  end
end
