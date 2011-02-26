module RailsCachingModels
  def self.included(base)
    base.send :extend, ClassMethods
    base.send :after_update, :update_cache
    base.send :after_create, :clear_all_ids
    base.send :after_destroy, :clear_all_ids
  end
 
  module ClassMethods 
    def acts_as_cacheable
      send :include, InstanceMethods
    end
    
    def get(id)
      ck = "#{name}_#{id}"
      thing = Rails.cache.fetch(ck) do
        find(id)
      end
      thing
    end
    
    def get_all
      ck = "#{name}_all_ids"
      all_ids = Rails.cache.fetch(ck) do
        all(:select => 'id').map(&:id)
      end
      all_ids.map { |id| get(id) }
    end
  end
 
  module InstanceMethods
    def update_cache
      Rails.cache.write("#{self.class.name}_#{id}", self)
    end
    
    def clear_all_ids
      Rails.cache.delete("#{self.class.name}_all_ids")
    end
  end
end

ActiveRecord::Base.send :include, RailsCachingModels
