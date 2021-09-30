class Movie < ActiveRecord::Base
    
    #attr_accessor :title, :rating, :description, :release_data
    def self.ratings
       ret = {}
       self.select(:rating).each do |m|
          ret[m.rating] = 1 
       end
        
        return ret.keys
    end
    
    def self.movies_ratings(ratings)
        self.where(:rating => ratings)
    end
    
    def self.movies_ratings_sort(ratings, sort_item)
        self.where(:rating => ratings).order(sort_item)
    end
    
end