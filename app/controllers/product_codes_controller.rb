class ProductCodesController < ApplicationController
  
  #TODO: Authenticate the correct user
  
  def create
    @product_code = ProductCode.add_new(product_code_create_params)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  def new
    @product_code = ProductCode.new
  end
  
  def edit
    @product_code = ProductCode.find(params[:id])

    if(@product_code.nil?)
      flash[:error] = "You have requested an invalid data item to edit"
      redirect_to root_path
      return
    end
  end
  
  def update
    @product_code = ProductCode.find(params[:id])
    
    if(@product_code.nil?)
      flash[:error] = "You are trying to update an invalid product code"
      redirect_to root_path
      return
    end
    
    if @product_code.update_attributes(product_code_create_params)
      redirect_to "/product_codes/#{@product_code.id}/edit", :notice => 'Data was successfully updated.'
    else
      respond_to do |format|
        format.html { render :action => "edit" }
        format.json { render :json => @product_code.errors, :status => 422}
      end
    end
  end

  def destroy
    @product_code = ProductCode.find(params[:id])
    
    if(@product_code.nil?)
      flash[:error] = "You are trying to destroy an invalid color"
      redirect_to root_path
      return
    end
    
    @product_code.delete
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

  def product_code_create_params
    params.require(:product_code).permit(:name, :description)
  end
  
end