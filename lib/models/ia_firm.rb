require_relative './investor_record'

class IAFirm < InvestorRecord

	FIELDS = [
    :name, :crd, :jurisdictions, :notice_filings, :exempt_reporting_advisers
    # TODO add an attribute to indicate IA firms that are also brokerage firms
  ]

  attr_accessor *FIELDS

  private

  def fields
    FIELDS
  end

  def table
    "ia_firms"
  end

end