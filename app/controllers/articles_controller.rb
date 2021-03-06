class ArticlesController < ApplicationController
  include ArticlesHelper

  before_filter :require_login, except: [:index, :show, :top_ten, :archive]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])

    @comment = Comment.new
    @comment.article_id = @article.id

  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.author_id = current_user.id
    if @article.save
      flash.notice = "Article '#{@article.title}' Created!"
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def destroy
    @article = Article.find(params[:id])

    flash.notice = "Article '#{@article.title}' Destroied!"

    @article.destroy

    redirect_to articles_path
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update(article_params)

    flash.notice = "Article '#{@article.title}' Updated!"

    redirect_to article_path(@article)
  end

  def top_ten
    @articles = Article.top
  end

  def archive
    articles_archives = Article.archives
    @monthyear = params[:archive]
    @articles = articles_archives[@monthyear]
  end

end
