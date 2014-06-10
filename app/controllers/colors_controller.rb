class ColorsController < ApplicationController
  
  #TODO: Authenticate the correct user
  
  def create
    p "---"
    p params
    p "---"
    @color = Color.add_new(color_create_params)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  def new
    @color = Color.new
  end

=begin
  def edit
    @app = App.find(params[:id])

    if(@app.nil?)
      flash[:error] = "You have requested an invalid data item to edit"
      redirect_to merchant_session_url
      return
    end
    
    if @app.merchant_id == current_merchant.id
      respond_to do |format|
        format.html
      end
    else
      flash[:error] = "You are unauthorized to access this section"
      redirect_to merchant_session_url
    end
    
  end
  
  def update
    @app = App.find(params[:id])
    
    if(@app.nil?)
      flash[:error] = "You are trying to update an invalid app"
      redirect_to merchant_session_url
      return
    end
    
    if @app.merchant_id == current_merchant.id
      if @app.update_attributes(app_create_params)
        redirect_to "/apps/#{@app.id}/edit", :notice => 'Data was successfully updated.'
      else
        respond_to do |format|
          format.html { render :action => "edit" }
          format.json { render :json => @app.errors, :status => 422}
        end
      end
    else
      respond_to do |format|
        flash[:error] = "You are unauthorized to access this section"
        redirect_to merchant_session_url
      end
    end
        
  end
  
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

  def color_create_params
    params.require(:color).permit(:code, :image_url)
  end
  
end