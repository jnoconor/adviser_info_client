require_relative './investor_record'

class IARepresentative < InvestorRecord
  FIELDS = [
      :name, :crd, :last_updated, :current_employers, :current_qualifications, :registration_history,
#      :disclosure_information, :broker_dealer_information
    ]

  attr_accessor *FIELDS

def to_s
    "#{crd} #{name}"
  end

  private

  def fields
    FIELDS
  end

end