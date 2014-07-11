class ProductsController < ApplicationController
  
  #TODO: Authenticate the correct user
  
  def create
    @product = Product.add_new(product_create_params)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  
  rescue Mongoid::Errors::Validations => e
    @errors = e.document.errors
    @order  = e.document
    
    Rails.logger.error "Error creating product : #{e.message}"
    
    respond_to do |format|
      format.json { render json: {errors: @errors}, status: 422 }
    end
    
  end

  def new
    @product = Product.new
  end
  
  def edit
    @product = Product.find(params[:id])

    if(@product.nil?)
      flash[:error] = "You have requested an invalid data item to edit"
      redirect_to root_path
      return
    end
  end
  
  def update
    @product = Product.find(params[:id])
    
    if(@product.nil?)
      flash[:error] = "You are trying to update an invalid product"
      redirect_to root_path
      return
    end
    
    if @product.update_attributes(product_create_params)
      redirect_to "/products/#{@product.id}/edit", :notice => 'Data was successfully updated.'
    else
      respond_to do |format|
        format.html { render :action => "edit" }
        format.json { render :json => @product.errors, :status => 422}
      end
    end        
  end
  
  def destroy
    @product = Product.find(params[:id])
    
    if(@product.nil?)
      flash[:error] = "You are trying to destroy an invalid app"
      redirect_to root_path
      return
    end
    
    @product.delete
  end

  private

  def product_create_params
    params.require(:product).permit(:title, :palette, :variation_number, :model_number, :pricing, :short_description, :long_description, :length, :breadth, :height, :depth, :weight, :material_type, :mounting_type, :finish_type, :usage_terms, :cleaning_of_product, :warranty_terms, :warranty_period, :left_angle_render_url, :right_angle_render_url, :front_render_url, :decorated_front_render_url, :product_code, :color)
  end
  
end