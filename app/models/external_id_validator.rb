class ExternalIdValidator < ActiveModel::Validator
  def validate(record)
    if record.external_id.nil?
      unless record.type == Scorething::ThingTypes::HASHTAG
        record.errors[:external_id] = "thing requires external_id unless it has type #{Scorething::ThingTypes::HASHTAG}"
      end
    end
  end
end
