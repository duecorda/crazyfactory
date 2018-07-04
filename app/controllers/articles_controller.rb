class ArticlesController < ApplicationController

  layout 'admin'

  def asks
    @asks = Ask.all.q

    @asks = @asks.x if params[:term] == "wait"
    @asks = @asks.c if params[:term] == "answered"

    @asks = @asks.order("id desc")
  end

  def new_answer
    @question = Ask.find(params[:ask_id])
    @ask = Ask.new(question_id: @question.id)
  end

  def edit_answer
    @question = Ask.find(params[:ask_id])
    @ask = Ask.find(params[:answer_id])
  end


  def index
    @articles = Article

    @articles = @articles.where(tab: params[:tab]) if params[:tab].present?
    @articles = @articles.where(category: params[:cate]) if params[:cate].present?

    @articles = @articles.order("id desc")
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to articles_path
    else
      flash[:notice] = @article.errors.values.flatten.to_sentence
      render action: :new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(article_params)
      redirect_to articles_path
    else
      flash[:notice] = @article.errors.values.flatten.to_sentence
      render action: :new
    end
  end

  private
    def article_params
      params.require(:article).permit!
    end

end
