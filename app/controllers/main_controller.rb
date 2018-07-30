class MainController < ApplicationController

  def photos
    @photos = Article.where(tab: "photos")
    if params[:cate].present?
      @photos = @photos.where(category: params[:cate])
    end
    @photos = @photos.order("id desc").page(params[:page]).per(10)
  end

  def show
    @article = Article.find(params[:id])
    render layout: false
  end

end
