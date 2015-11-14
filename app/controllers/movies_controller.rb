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
		@all_ratings = Movie.uniq.pluck(:rating).sort
		@highlight_class = "hilite"		

		if params[:sort].present?
			@sort = params[:sort]
			session[:sort] = @sort
		else
			@sort = session[:sort]
		end

		if params[:ratings]
			params[:ratings].is_a?(Array) ? @ratings = params[:ratings] : @ratings = params[:ratings].keys
			session[:ratings] = @ratings
		elsif @ratings.nil?
			@ratings = session[:ratings] || @all_ratings
		else			
			@ratings = session[:ratings]
		end
		
		@movies = Movie.where(rating: @ratings).order(@sort)

		if params[:sort] != session[:sort] and params[:ratings] != session[:ratings]
			flash.keep
			redirect_to movies_path(sort: @sort,  ratings: @ratings) 
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

end
