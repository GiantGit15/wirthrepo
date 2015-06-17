class PhotosController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :set_photo, only: [:show, :show_branded, :print, :share]

  def show
    file_path = "#{project_path.to_s}/#{@photo.display_path}"
    send_file(file_path, disposition: 'inline')
  rescue
    @photo.destroy
  end

  def show_branded
    file_path = "#{project_path.to_s}/#{@photo.branded_path}"
    send_file(file_path, disposition: 'inline')
  rescue
    @photo.destroy
  end

  def print
    @photo.print

    render "print.json"
  end

  def share
    @photo.share(params[:share_content])

    render json: true
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def set_photo
    @photo = Photo.find(params[:id])
  end

end
