require_relative './investor_record_parser'

class BrokerParser < InvestorRecordParser

  class << self

    private

    def target_class
      Broker
    end


    def find_crd
      doc.css(".summarydisplaycrd").text[/\d+/]
    end

    def find_is_licensed
      summaryheader = doc.css(".summaryheadertext").first
      if summaryheader
        summaryheader = summaryheader.text.strip
      end
      licensed = summaryheader[/not licensed/i] ? false : true
    end

    def find_disclosures
      table = doc.css("#disclosuretable")
      if table
        table.css("tr .discfirstcolumn").map do |column|
          row = column.parent
          {
            date: row.css(".discfirstcolumn").text.strip,
            classification: row.css(".discsecondcolumn").text.strip
          }
        end
      end
    end

    def find_years_in_securities_industry
    end

    def find_passed_exams
    end

    def find_current_registrations
    end


    def find_past_registrations
    end

    def find_alternate_names
    end

  end

end