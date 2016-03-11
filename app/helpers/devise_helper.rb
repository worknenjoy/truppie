module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="error-notice animated flipInY">
      <div class="oaerror danger">
        <strong> #{messages} </strong>
      </div>
    </div>
    HTML

    html.html_safe
  end
end