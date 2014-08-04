class UploadsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :check_configuration
  load_and_authorize_resource :except => [:create]
  
  def check_configuration
    render 'configuration_missing' if Cloudinary.config.api_key.blank?
  end
  
  def create
    uploaded_file = params[:uploaded_file]
    file_type = params[:file_type]
    if !uploaded_file.nil? && (uploaded_file.respond_to?(:tempfile) and uploaded_file.tempfile.is_a?(Tempfile))  
      response = Cloudinary::Uploader.upload uploaded_file, :tags => "basic_sample"  
      uploaded_url = response["secure_url"]
      new_upload = Upload.new()
      new_upload.type = file_type
      new_upload.url = uploaded_url
      new_upload.save!
    else
      uploaded_url = ""
    end

    respond_to do |format|
      format.html { render text: uploaded_url, status: 200 }
      format.json { render text: uploaded_url, status: 200 }
    end
  end

end #__End of class UploadsController__
