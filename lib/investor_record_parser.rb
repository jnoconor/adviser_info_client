require 'nokogiri'

class InvestorRecordParser
  class << self
    attr_accessor :doc

    def create(html)
      @doc = Nokogiri::HTML(html)
      target_class.new(parsed_doc)
    end

    private

    def target_class
      raise "Define in child class"
    end

    def parsed_doc
      target_class::FIELDS.each_with_object({}) do |field, hash|
        hash[field] = send("find_#{field}")
      end
    end
  end
end