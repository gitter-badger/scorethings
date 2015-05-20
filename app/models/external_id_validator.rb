class ExternalIdValidator < ActiveModel::Validator
  def validate(record)
    if record.external_id.nil?
      unless record.type == Scorethings::ThingTypes::HASHTAG
        record.errors[:external_id] = "things requires external_id unless it has type #{Scorethings::ThingTypes::HASHTAG}"
      end
    end
  end
end
