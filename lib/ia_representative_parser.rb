require 'pry'
require_relative './investor_record_parser'

class IARepresentativeParser < InvestorRecordParser

  class << self

    private

    def target_class
      IARepresentative
    end

    def find_name
      doc.css("#indvlSummary .summary-displayname").text.strip
    end

    def find_crd
      doc.css("#indvlSummary .summary-displaycrd").text.strip[/\d+/]
    end

    def find_last_updated
      date_regex = /\d{2}\/\d{2}\/\d{4}/
      doc.css("#indvlSummary b").text[date_regex]
    end

    def find_current_employers
      employer_row = find_row_with_header("current employers")
      employer_row.css("b").text if employer_row
    end

    def find_current_qualifications
      qual_row = find_row_with_header("qualifications")
      suspended_regex = /suspended.*jurisdiction[.]*\?[\\n|\b|\s]*([a-zA-Z]+)[\\n|\b|\s]*/i
      if qual_row
        jurisdictions = qual_row.text.match(/currently registered.*(\d+).*jurisdiction/)[1]
        suspended = qual_row.text.match(suspended_regex)[1] == "Yes"
      end
      {
        jurisdictions: jurisdictions,
        suspended: suspended || "No"
      }
    end

    def find_registration_history
      row = find_row_with_header("registration history")
      return [] if row.nil?
      table = row.css("table tr")
      header = table.shift
      table.map do |row|
        firm_info = row.css("td").first.text
        {
          firm_name: firm_info.split(/\(iard/i).first.strip,
          firm_iard: firm_info[/\d+/],
          firm_location: firm_info.split("-").last.gsub(/^\W*/, "").strip,
          dates: row.css("td")[1] && row.css("td")[1].text.strip
        }
      end
    end

    def find_disclosure_information

    end

    def find_broker_dealer_information

    end

    def find_row_with_header(header, tag = "h4")
      row = doc.css("#{tag}").find { |x| x.text[Regexp.new("#{header}", "i")] }
      return if row.nil?
      row = row.parent
      while row.xpath("@class").text != "bcrow"
        row = row.parent
      end
      row
    end

  end
end