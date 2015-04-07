module FormHelper
  def field_error(model, attribute)
    if model.errors[attribute].any?
      content_tag :div, model.errors[attribute].join(', '),
        class: 'ui red pointing prompt label'
    end
  end

  def field(model, attribute, &block)
    css = %w(field)
    css << 'error' if model.errors[attribute].any?
    content_tag(:div, class: css.join(' ')) do
      contents = []
      contents << capture(&block) if block_given?
      contents << capture{ field_error(model, attribute) }
      contents.compact.join('').html_safe
    end
  end
end
