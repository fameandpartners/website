class Blog::CelebrityPhotosController < ApplicationController
  def show
    @photo = Blog::CelebrityPhoto.find(params[:id])
  end
end
