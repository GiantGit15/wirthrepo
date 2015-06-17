class BrandingController < ApplicationController
  protect_from_forgery with: :null_session

  # Currently only id=1 is used. Higher numbers are left open for the future.
  # Serve the file or if it doesnt exist give a 204-no content.
  def show
    file_path = PNS.branding_path(Event.latest.try(:name), params[:id])
    p file_path
    if File.file?(file_path)
      send_file(file_path, disposition: 'inline')
    else
      head :no_content
    end
  rescue
    head :no_content
  end
end
