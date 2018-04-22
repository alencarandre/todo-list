module FormHelper

  def input_text(field, f)
    input_field(field, f, as: :text)
  end

  def input_email(field, f)
    input_field(field, f, as: :email)
  end

  def input_password(field, f)
    input_field(field, f, as: :password)
  end

  def input_select(field, f, options = [])
    input_field(field, f, as: :select, options: options)
  end

  def input_field(field, f, options={})
    content_tag(:div, class: "form-group")do
      concat f.label(field)

      concat render_field(field, f, options)

      if f.object.errors.present?
        error = f.object.errors[:"#{field}"].first
        concat(content_tag(:span, class: "error") { error })
      end
    end
  end

  private

  def render_field(field, f, options = {})
    case options[:as].to_sym
    when :text
      f.text_field(field, class: "form-control")
    when :email
      f.email_field(field, class: "form-control", autofocus: true, autocomplete: "email")
    when :password
      f.password_field(field, class: "form-control", autocomplete: "off")
    when :select
      f.select field, options[:options], {}, class: "form-control"
    end
  end

end
