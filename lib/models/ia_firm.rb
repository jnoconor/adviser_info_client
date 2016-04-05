require_relative './investor_record'

class IAFirm < InvestorRecord

	FIELDS = [
    :name, :crd, :jurisdictions, :notice_filings, :exempt_reporting_advisers
  ]

  attr_accessor *FIELDS

  private

  def fields
    FIELDS
  end

end