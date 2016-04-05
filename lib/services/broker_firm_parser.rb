require_relative './investor_record_parser'

class BrokerFirmParser < InvestorRecordParser

  class << self
    private

    def target_class
      BrokerFirm
    end

    def find_name
      doc.css(".summarydisplayname").text.strip
    end

    def find_crd
      crd_section = doc.css(".summarydisplaycrd").text.split("/").first
      if crd_section
        crd_section[/\d+/]
      end
    end

    def find_sec
      sec_section = doc.css(".summarydisplaycrd").text.split("/").last
      if sec_section
        sec_section[/\d+.*\d+/]
      end
    end

    def find_business_types
      row = find_row_from_img("registered")
      types = row.css(".summaryheadertext").map { |n| n.text.strip }
    end

    def find_disclosures
      row = doc.css("#dvDiscContent")
      row.css(".FirmNestedListItemColor").map do |n|
        data = n.css("div")
        {
          type: data[0].text.strip,
          count: data[1].text.strip
        }
      end
    end

    def find_firm_details
      row = find_row_from_img("briefcase")
      detail_section = row.css(".summarysectionrightpanel")
      date = detail_section.css(".summaryheadertext").text[/\d+\/\d+\/\d+/]
      address_section = detail_section.css(".firmprofilesecondcolumn .firmprofilecell").last
      address = address_section.children.select { |n| n.name != "br" }.map(&:text).join("\n")
      phone = doc.xpath("//*[text()='Business Telephone Number']").first.parent.parent.text[/\d+-\d+-\d+/]
      owners = doc.css(".bcrow .FirmNestedListItemColor .Padding15").map do |row|
        name, role = row.text.split(" - ")
        {
          name: name.strip,
          role: role.strip
        }
      end
      {
        date_formed: date,
        mailing_address: address,
        business_phone: phone,
        owners_and_officers: owners
      }
    end

    def find_row_from_img(title_match)
      row = doc.css(".summarysectionleftpanel img").find { |i| i.attr("src").match(title_match) }.parent
      while !row.xpath("@class").text.include?("bcrow")
        row = row.parent
      end
      row
    end

  end
end