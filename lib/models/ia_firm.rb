require_relative './investor_record'

class IAFirm < InvestorRecord

	FIELDS = [
    :name, :crd, :jurisdiction, :registration_status, :effective_date
  ]

  attr_accessor *FIELDS

end