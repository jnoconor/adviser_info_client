require 'pry'
require 'nokogiri'

class IARepresentativeParser

  class << self
    attr_accessor :doc

    def create(html)
      @doc = Nokogiri::HTML(html)
      IARepresentative.new(parsed_doc)
    end

    private

    def parsed_doc
      {
        name: find_name,
        crd: find_crd,
        last_updated: find_last_updated,
        current_employers: find_current_employers,
        qualifications: find_current_qualifications,
        registration_history: find_registration_history,
        disclosure_information: find_disclosure_information,
        broker_dealer_information: find_broker_dealer_information
      }
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
      jurisdictions = qual_row.text.match(/currently registered.*(\d+).*jurisdiction/)[1]
      suspended_regex = /suspended.*jurisdiction[.]*\?[\\n|\b|\s]*([a-zA-Z]+)[\\n|\b|\s]*/i
      suspended = qual_row.text.match(suspended_regex)[1]
      suspended = suspended == "No" ? false : true
      {
        jurisdictions: jurisdictions,
        suspended: suspended
      }
    end

    def find_registration_history

    end

    def find_disclosure_information

    end

    def find_broker_dealer_information

    end

    def find_row_with_header(header, tag = "h4")
      row = doc.css("#{tag}").find { |x| x.text[Regexp.new("#{header}", "i")] }.parent
      while row.xpath("@class").text != "bcrow"
        row = row.parent
      end
      row
    end

  end
end