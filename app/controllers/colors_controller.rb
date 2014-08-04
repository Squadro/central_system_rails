class ColorsController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:create]
  
  def create
    @color = Color.add_new(color_create_params)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
    
  rescue Mongoid::Errors::Validations => e
    @errors = e.document.errors
    @color  = e.document
    
    Rails.logger.error "Error creating color: #{e.message}"
    
    respond_to do |format|
      format.html { render :new, errors: @errors }
      format.json { render json: {errors: @errors}, status: 422 }
    end
  end

  def new
  end

  def edit
    if(@color.nil?)
      flash[:error] = "You have requested an invalid data item to edit"
      redirect_to root_path
      return
    end
  end
  
  def update
    if(@color.nil?)
      flash[:error] = "You are trying to update an invalid color"
      redirect_to root_path
      return
    end
    
    result = @color.update_attributes!(color_create_params)
    redirect_to "/colors/#{@color.id}/edit", :notice => 'Data was successfully updated.'
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
    if(@color.nil?)
      flash[:error] = "You are trying to destroy an invalid color"
      redirect_to root_path
      return
    end
    
    @color.delete
  end

  private

  def color_create_params
    params.require(:color).permit(:code, :laminate_brand, :catalogue_type, :catalogue_page_no, :vendor_product_code, :grain_type, :finish_type, :meta, :image_url)
  end
  
end