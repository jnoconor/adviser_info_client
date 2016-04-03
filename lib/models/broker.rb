require_relative './investor_record'

class Broker < InvestorRecord

  FIELDS = [
    :crd, :is_licensed, :disclosures, :years_in_securities_industry, :passed_exams, :current_registrations,
    :past_registrations, :alternate_names
  ]

  attr_accessor *FIELDS

  private

  def fields
    FIELDS
  end

end