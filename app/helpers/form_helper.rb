module FormHelper
  def field_error(model, attribute)
    return unless model.errors[attribute].any?
    content_tag :div, model.errors[attribute].join(', '),
                class: 'ui red pointing prompt label'
  end

  def field(model, attribute, &block)
    content_tag(:div, class: field_css(model, attribute)) do
      contents = []
      contents << capture(&block) if block_given?
      contents << capture { field_error(model, attribute) }
      contents.compact.join('').html_safe
    end
  end

  def field_css(model, attribute)
    css = %w(field)
    css << 'error' if model.errors[attribute].any?
    css.join(' ')
  end
end
