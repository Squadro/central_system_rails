class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery  # with: :exception
  
  #check_authorization   # ensure authorization happens on every action in your application
  rescue_from Exception, with: :handle_exception
  
  def root
    if current_user
      @products = Product.all.order_by(:model_code.asc, :title.asc).to_a
      @palettes = Palette.all.order_by(:code.asc).to_a
      @product_codes = ProductCode.all.order_by(:name.asc).to_a
      @all_colors = Color.all.order_by(:code.asc).to_a
      @users = User.all.order_by(:email.asc).to_a
      ActionController::Base.config.relative_url_root = ''
    end
  end
  
  def auth_token
    respond_to do |format|
      format.json { render json: {token: form_authenticity_token}, status: 200 }
      format.html { render text: form_authenticity_token, status: 200 }
    end
  end
  
  private
  def handle_exception(e)
    log_exception(e)
    raise if e.class == ActionController::ParameterMissing
    
    unless performed?
      respond_to do |format|
        format.html { render text: "Something went wrong. We are looking into it. Error details: #{e.class}, #{e.message}, #{e.backtrace.slice(0, stack_depth).join("\n")}", status: 500 }
        format.json { render json: {msg: "Something went wrong. We are looking into it. Error details: #{e.class}, #{e.message}, #{e.backtrace.slice(0, stack_depth).join("\n")}"}, status: 500 }
      end
    end
  end
  
  def log_exception(e, stack_depth = 5)
    Rails.logger.error "Caught exception : #{e.class} : #{e.message}"
    Rails.logger.error e.backtrace.slice(0, stack_depth).join("\n")
  end
  
end
