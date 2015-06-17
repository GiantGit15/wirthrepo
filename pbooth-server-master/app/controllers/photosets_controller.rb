class PhotosetsController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :set_photoset, only: [:show, :show_branded, :print, :share]

  def show
    file_path = "#{project_path.to_s}/#{@photoset.display_path}"
    send_file(file_path, disposition: 'inline')
  rescue
    @photoset.destroy
  end

  def show_branded
    file_path = "#{project_path.to_s}/#{@photoset.branded_path}"
    send_file(file_path, disposition: 'inline')
  rescue
    @photoset.destroy
  end

  # POST photosets/:id/print
  def print
    puts "printing #{params[:id]}"
    @photoset.print

    render "print.json"
  end

  def share
    @photoset.share(params[:share_content])

    render json: true
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def set_photoset
    @photoset = Photoset.find(params[:id])
  end
end
