class AsksController < ApplicationController

  def new
    @ask = Ask.new
  end

end
