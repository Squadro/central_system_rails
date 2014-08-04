module UserHelper
  
  def signup_error_messages!
    return "" if @user.errors.empty?
    
    messages = @user.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => @user.errors.count,
                      :resource => @user.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation" class="errorBox">
      <i>#{sentence}</i>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end
