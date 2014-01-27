class UniquePageNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.match(/\s+/)
      route = Rails.application.routes.recognize_path("/#{value}")
      if route[:controller] != "user" && route[:action] != "show"
        record.errors.add(attribute, "'#{value}' is reserved")
      end
    end
  end
end
