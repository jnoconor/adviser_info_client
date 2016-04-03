# require 'adviser_info_parser'
require 'open-uri'

class SecClient

	DEFAULT_ENDPOINT = "http://www.adviserinfo.sec.gov/"

	attr_reader :endpoint

	def initialize(config = {})
		@endpoint = config[:endpoint] || DEFAULT_ENDPOINT
		@parser = config[:parser]
	end

	def get(id, opts = {})

	end

	def write

	end

	def save

	end

	private


end