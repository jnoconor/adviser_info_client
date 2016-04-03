require 'pry'
require_relative './investor_record_parser'

class IAFirmParser < InvestorRecordParser

  class << self

    private

    def target_class
      IAFirm
    end

    def name
    end

    def crd
    end

    def jurisdiction
    end

    def registration_status
    end

    def effective_date
    end

  end
end