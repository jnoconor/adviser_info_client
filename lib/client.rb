require 'pry'
require 'open-uri'
require_relative './models/ia_representative'
require_relative './history'
require_relative './ia_representative_parser'

class SecClient

	DEFAULT_ENDPOINT = "http://www.adviserinfo.sec.gov/"
	DEFAULT_PARSER = nil

	attr_reader :endpoint, :parser

	def initialize(config = {})
		@endpoint = config[:endpoint] || DEFAULT_ENDPOINT
		@parser = config[:parser] || DEFAULT_PARSER
		@history = History.new(config)
	end

	def get(id, opts = {})
		html = open(resource_uri(id))
		rep = IARepresentativeParser.create(html)
		after_get(rep)
	end

	def write

	end

	def save

	end

	def history
		@history.list
	end

	private

  def after_get(object)
    @history.add(object)
    object # always return the object
  end

	def parser
	end

	def resource_uri(id)
		"http://www.adviserinfo.sec.gov/IAPD/IAPDIndvlSummary.aspx?INDVL_PK=#{id}"
	end


end