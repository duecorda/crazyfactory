class PhotosController < ApplicationController

  def create
    res = {:files => []}

    params[:photo][:attachment].each do |attachment|

      @photo = Photo.new(attachment: attachment)
      if @photo.save
        res[:files].push({
          :photo_id => @photo.id,
          :name => @photo.original_filename,
          :url => @photo.url(:thumb),
          :html => render_to_string(partial: 'photo', locals: { photo: @photo })
        })
      end
    end

    render :content_type => request.format, :json => res.to_json
  end

  def destroy
    @photo = Photo.find(params[:id])
    # @ret = @photo.destroy
  end

end
