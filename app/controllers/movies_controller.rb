class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def old_index
    @movies = Movie.all
  end

def index
    if params[:commit] == 'Refresh' && !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    elsif session[:ratings] != params[:ratings]
      redirect = true
      params[:ratings] = session[:ratings]
    end

    if params[:orderby]
      session[:orderby] = params[:orderby]
    elsif session[:orderby]
      redirect = true
      params[:orderby] = session[:orderby]
    end
    
    @ratings, @orderby = session[:ratings], session[:orderby]
    if redirect
      flash.keep
      redirect_to movies_path({:orderby=>@orderby, :ratings=>@ratings})
    elsif
      columns = {'title'=>'title', 'release_date'=>'release_date'}
      if columns.has_key?(@orderby)
        query = Movie.order(columns[@orderby])
      else
        @orderby = nil
        query = Movie
      end
      

      if(@ratings.nil?)
	@ratings={'G'=>'G','PG'=>'PG','PG-13'=>'PG-13','R'=>'R','NC-17'=>'NC-17'}
	@movies = query.all
      else
	#@movies = query.find_all_by_rating(@ratings.map { |r,v| v })
	@movies = query.find_all_by_rating(@ratings.keys)
      end
      @all_ratings = Movie.ratings  
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
