class AsksController < ApplicationController

  def new
    @ask = Ask.new(question_id: 0, answered: 0)
    @asks = Ask.all.q.order("id desc")
  end

  def create
    @ask = Ask.new(ask_params)

    if @ask.save
      if @ask.is_answer?
        redirect_to asks_articles_path
      else
        redirect_to new_ask_path
      end
    else
      @asks = Ask.all.q.order("id desc")
      flash[:notice] = @ask.errors.values.flatten.to_sentence
      render action: :new
    end
  end

  def edit
    @article = Ask.find(params[:id])
  end

  def update
    @ask = Ask.find(params[:id])

    if @ask.update_attributes(ask_params)
      if @ask.is_answer?
        redirect_to asks_articles_path
      else
        redirect_to new_ask_path
      end
    else
      flash[:notice] = @ask.errors.values.flatten.to_sentence
      render action: :new
    end
  end

  private
    def ask_params
      params.require(:ask).permit!
    end

end
