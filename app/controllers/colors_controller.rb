class ColorsController < ApplicationController
  
  #TODO: Authenticate the correct user
  
  def create
    @color = Color.add_new(color_create_params)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
    
    #TODO : Add Validation error handling
  end

  def new
    @color = Color.new
  end

  def edit
    @color = Color.find(params[:id])

    if(@color.nil?)
      flash[:error] = "You have requested an invalid data item to edit"
      redirect_to root_path
      return
    end
  end
  
  def update
    @color = Color.find(params[:id])
    
    if(@color.nil?)
      flash[:error] = "You are trying to update an invalid color"
      redirect_to root_path
      return
    end
    
    if @color.update_attributes(color_create_params)
      redirect_to "/colors/#{@color.id}/edit", :notice => 'Data was successfully updated.'
    else
      respond_to do |format|
        format.html { render :action => "edit" }
        format.json { render :json => @color.errors, :status => 422}
      end
    end
  end

  def destroy
    @color = Color.find(params[:id])
    
    if(@color.nil?)
      flash[:error] = "You are trying to destroy an invalid color"
      redirect_to root_path
      return
    end
    
    @color.delete
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
=end
  private

  def color_create_params
    params.require(:color).permit(:code, :laminate_brand, :catalogue_type, :catalogue_page_no, :vendor_product_code, :grain_type, :finish_type, :meta, :image_url)
  end
  
end