require_relative './investor_record_parser'

class BrokerFirmParser < InvestorRecordParser

  class << self
    private

    def target_class
      BrokerFirm
    end
  end
end