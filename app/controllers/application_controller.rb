class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery  #with: :exception
  
  rescue_from Exception, with: :handle_exception
  
  def root
    # TODO: Authenticate/Authorize
    #if current_merchant
      @products = Product.all.to_a
      @palettes = Palette.all.to_a
      @product_codes = ProductCode.all.to_a
      @all_colors = Color.all.to_a
      ActionController::Base.config.relative_url_root = ''
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
        format.html { render text: "Something went wrong. We are looking into it", status: 500 }
        format.json { render json: {msg: "Something went wrong. We are looking into it"}, status: 500 }
      end
    end
  end
  
  def log_exception(e, stack_depth = 5)
    Rails.logger.error "Caught exception : #{e.class} : #{e.message}"
    Rails.logger.error e.backtrace.slice(0, stack_depth).join("\n")
  end
  
end
