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
        jurisdictions = qual_row.text.match(/currently registered.*(\d+).*jurisdiction/)
        if jurisdictions
          jurisdictions = jurisdictions[1]
        end
        suspended = qual_row.text.match(suspended_regex)
        if suspended
          suspended = suspended[1] == "Yes"
        end
      end
      {
        jurisdictions: jurisdictions || 0,
        suspended: suspended || "No"
      }
    end

    def find_registration_history
      table_rows = find_table_rows_under_header("registration history")
      table_rows.map do |row|
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
      table_rows = find_table_rows_under_header("disclosure information")
      table_rows.map do |row|
        type, count = row.css("td").map(&:text)
        {
          type: type,
          count: count
        }
      end
    end

    def find_broker_dealer_information
      row = find_row_with_header("broker dealer information")
      return "Not a broker" if row.nil?
      # TODO figure out what to do with this
      row.css("a").attr("href").value
    end

    def find_table_rows_under_header(header)
      row = find_row_with_header(header)
      return [] if row.nil?
      table_rows = row.css("table tr")
      header = table_rows.shift
      table_rows
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