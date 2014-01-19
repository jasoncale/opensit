class NoEmptySpacesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, "cannot contain spaces") if value.match(/\s+/)
  end
end
