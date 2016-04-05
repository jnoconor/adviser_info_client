require_relative './investor_record'

class BrokerFirm < InvestorRecord

  FIELDS = [

  ]

  attr_accessor *FIELDS

  private

  def fields
    FIELDS
  end

end