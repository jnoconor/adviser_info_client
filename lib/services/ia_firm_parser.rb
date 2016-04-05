require_relative './investor_record_parser'

class IAFirmParser < InvestorRecordParser

  class << self

    private

    def target_class
      IAFirm
    end

    def find_name
      doc.css(".summary-displayname").text.strip
    end

    def find_crd
      doc.css(".summary-displaycrd").text[/\d+/]
    end

    def find_jurisdictions
      rows = doc.css("#tbRegStatus tr")
      header = rows.shift
      rows.map do |row|
        data = row.css("td")
        {
          jurisdiction: data[0].text.strip,
          registration_status: data[1].text.strip,
          effective_date: data[2].text.strip
        }
      end
    end

    def find_notice_filings
      rows = doc.css("#tbNtcStatus tr")
      header = rows.shift
      rows.map do |row|
        data = row.css("td")
        {
          jurisdiction: data[0].text.strip,
          effective_date: data[1].text.strip
        }
      end
    end

    def find_exempt_reporting_advisers
      rows = doc.css("#tbERAStatus tr")
      header = rows.shift
      rows.map do |row|
        data = row.css("td")
        {
          jurisdiction: data[0].text.strip,
          reporting_status: data[1].text.strip,
          effective_date: data[2].text.strip
        }
      end
    end

  end
end