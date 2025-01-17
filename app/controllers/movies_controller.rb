class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index

      @all_ratings = Movie.ratings
      
      if params.has_key?(:sort)==false && params.has_key?(:ratings)==false
        if session.has_key?(:sort) || session.has_key?(:ratings)
          redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
        end
      end
      
      
      if params.has_key?(:sort)
        @sort = params[:sort]
        session[:sort] = @sort
      else
        @sort = session[:sort]
      end
      
      if params.has_key?(:commit) || params.has_key?(:ratings)
        @ratings_checked = params[:ratings]
        session[:ratings] = params[:ratings]
      #elsif params.has_key?(:ratings)
      #  @ratings_checked = params[:ratings]
      #  session[:ratings] = params[:ratings]
      else
        @ratings_checked = session[:ratings]
      end
      
      if @sort == nil
        if @ratings_checked == nil
          @movies = Movie.all
        else
          @movies = Movie.movies_ratings(@ratings_checked.keys)
        end
      else
        if @ratings_checked == nil
          @movies = Movie.order(@sort)
        else
          @movies = Movie.movies_ratings_sort(@ratings_checked.keys, @sort)
        end
      end
      
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
    
    def showcss(head)
      params[:sort] == head ? 'hilite' : nil
    end
    helper_method :showcss
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end