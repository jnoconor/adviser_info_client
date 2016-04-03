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
        licensed = summaryheader[/not licensed/i] ? false : true
      end
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
      doc.text.match(/.*(\d+).*year\(s\).*in securities industry/i)
    end

    def find_passed_exams
      doc.css("#examSection .summaryheadertext").text[/\d+/]
    end

    def find_current_registrations
      current_reg = doc.css("#registrationSection .currregfirstcolumn")
      current_reg.map do |column|
        firm_info = column.parent.css(".currregsecondcolumn").text.strip
        {
          firm_name: firm_info.split(/\(crd/i)[0].strip,
          firm_crd: firm_info[/\d+/],
          since: column.parent.css(".currregfirstcolumn").text[/\d{2}\/\d{4}/]
        }
      end
    end

    def find_past_registrations
      prev_reg = doc.css("#prevregistrationSection .prevregfirstcolumn")
      prev_reg.map do |column|
        firm_info = column.parent.css(".prevregsecondcolumn").text.strip
        {
          dates: column.parent.css(".prevregfirstcolumn").text.gsub(/\s|\r|\n/,"").strip,
          firm_name: firm_info.split(/\(crd/i)[0].strip,
          firm_crd: firm_info[/\d+/]
        }
      end
    end

    def find_alternate_names
      alts = doc.text.match(/alternate names:(.*)/i)
      if alts && alts[1]
        alts[1].split(",").map(&:strip)
      else
        []
      end
    end
  end

end