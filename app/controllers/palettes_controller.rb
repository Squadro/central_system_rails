class PalettesController < ApplicationController
  
  #TODO: Authenticate the correct user
  
  def create
    @palette = Palette.add_new(palette_create_params)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
    
  rescue Mongoid::Errors::Validations => e
    @errors = e.document.errors
    @palette  = e.document
    
    Rails.logger.error "Error creating palette: #{e.message}"
    
    respond_to do |format|
      format.html { render :new, errors: @errors }
      format.json { render json: {errors: @errors}, status: 422 }
    end
  end

  def new
    @palette = Palette.new
  end
  
  def edit
    @palette = Palette.find(params[:id])

    if(@palette.nil?)
      flash[:error] = "You have requested an invalid data item to edit"
      redirect_to root_url
      return
    end
  end
  
  def update
    @palette = Palette.find(params[:id])
    
    if(@palette.nil?)
      flash[:error] = "You have requested an invalid data item to edit"
      redirect_to root_url
      return
    end
    
    result = @palette.update_attributes!(palette_create_params)
    redirect_to "/palettes/#{@palette.id}/edit", :notice => 'Data was successfully updated.'
    return

  rescue Mongoid::Errors::Validations => e
    @errors = e.document.errors
    @palette  = e.document
    Rails.logger.error "Error updating palette: #{e.message}"
  
    respond_to do |format|
      format.html { render :edit, errors: @errors }
      format.json { render json: {errors: @errors}, status: 422 }
    end     
  end
  
  def destroy
    @palette = Palette.find(params[:id])
    
    if(@palette.nil?)
      flash[:error] = "You are trying to destroy an invalid app"
      redirect_to root_path
      return
    end
    
    @palette.delete
  end

=begin

  def redirect_to_bg_image_url
    @app = App.find(params[:id])
    default_image_url = "http://www.webweaver.nu/clipart/img/nature/planets/sun-wearing-sunglasses.png"
    
    if(@app.nil?)
      flash[:error] = "You have requested an invalid app"
      redirect_to default_image_url
      return
    end
    
    bg_image_url = @app.other_data["bg_image_url"] unless @app.other_data.nil?
    redirect_to (bg_image_url.blank? ? default_image_url : bg_image_url )
  end
  
  def notify_devices
    @app = App.find(params[:id])
    
    if(@app.nil?)
      flash[:error] = "You are trying to notify devices for an invalid app"
      redirect_to merchant_session_url
      return
    end
    
    @app.send_bulk_notifications(params)
    respond_to do |format|
      format.json { render json: {"msg" => "Delivered to all devices"} }
      format.html { render text: "Delivered to all devices" }
    end
  end

  def new_notification
    @app = App.find(params[:id])
    
    if(@app.nil?)
      flash[:error] = "You are trying to create notification for an invalid app"
      redirect_to merchant_session_url
      return
    end
    
  end

  def destroy
    #Don't know what all to destroy here
    @app = App.find(params[:id])
    
    if(@app.nil?)
      flash[:error] = "You are trying to destroy an invalid app"
      redirect_to merchant_session_url
      return
    end
    
    @app.delete
    
  end
=end
  private

  def palette_create_params
    params.require(:palette).permit(:code, :colors => [])
  end
  
end