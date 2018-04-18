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

  def input_field(field, f, as:)
    content_tag(:div, class: "form-group")do
      concat f.label(field)

      case :"#{as}"
      when :text
        concat f.text_field(field, class: "form-control")
      when :email
        concat f.email_field(field, class: "form-control", autofocus: true, autocomplete: "email")
      when :password
        concat f.password_field(field, class: "form-control", autocomplete: "off")
      end

      if f.object.errors.present?
        error = f.object.errors[:"#{field}"].first
        concat(content_tag(:span, class: "error") { error })
      end
    end
  end

end
