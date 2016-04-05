require_relative './investor_record'

class BrokerFirm < InvestorRecord

  FIELDS = [
    :name, :crd, :sec, :business_types, :disclosures, :firm_details
  ]

  attr_accessor *FIELDS

  private

  def fields
    FIELDS
  end

end