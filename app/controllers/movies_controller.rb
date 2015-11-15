class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @order_by = params[:order_by] ? params[:order_by] : flash[:order_by]
    @ratings = params.has_key?(:ratings) ? params[:ratings] : Hash[@all_ratings.map {|rating| [rating, 1]}]

    if @ratings.empty?
      @movies = Movie.all if @ratings.empty?
    else
      @movies = Movie.where(:rating => @ratings.keys) unless @ratings.empty?
    end
    
    @movies = @movies.order("#{@order_by} ASC") if @order_by
    
    flash[:order_by] = @order_by

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

end
