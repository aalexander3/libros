class BooksController < ApplicationController

  def index
    @books = Book.order(rating: :desc)
    @tags = Tag.all
  end

  def show
    @book = Book.find(params[:id])
    @discussion = Discussion.new
    @book_tag = BookTag.new(book_id: @book.id)
    @tag = Tag.new
  end

  def search
    if params[:query] == ""
      flash[:notice] = "Please input a valid title!"
      redirect_to books_path
    else
      @books = Book.make_book(params[:query])
      if @books.include? nil
        byebug
        flash[:notice] = "Please input a valid title!"
        redirect_to books_path
      elsif @books == []
        flash[:notice] = "Please input a valid title!"
        redirect_to books_path
      else
        @books
        render :index
      end
    end
  end

  def tag_search
    @books = Book.all.select do |book|
      book.tags.find_by("name LIKE ?", "%#{params[:query]}%")
    end
    render :index
  end

end
