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

    unless params.has_key?(:ratings) and !params[:ratings].empty? and params.has_key?(:order_by)
      redirect_to_index_with_all_params
    else
      @order_by = params[:order_by]
      @ratings = params[:ratings]

      if @ratings.empty?
        @movies = Movie.all
      else
        @movies = Movie.where(:rating => @ratings.keys)
      end

      @movies = @movies.order("#{@order_by} ASC") if @order_by

      session[:ratings] = @ratings
      session[:order_by] = @order_by
    end
  end

  def redirect_to_index_with_all_params
    session[:ratings] = Hash[@all_ratings.map {|rating| [rating, 1]}] unless session.has_key?(:ratings)
    session[:order_by] = 'id' unless session.has_key?(:order_by)

    @ratings = (params.has_key?(:ratings) and !params[:ratings].empty?) ? params[:ratings] : session[:ratings]
    @order_by = params.has_key?(:order_by) ? params[:order_by] : session[:order_by]

    flash.keep
    redirect_to movies_path(ratings: @ratings, order_by: @order_by)
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
