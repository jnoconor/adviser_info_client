require 'pry'
require 'open-uri'
require 'net/http'
require_relative './models/ia_representative'
require_relative './history'
require_relative './ia_representative_parser'

class SecClient
  class RemoteRecordNotFound < StandardError; end
  class RemoteServerError < StandardError; end

	DEFAULT_ENDPOINT = "http://www.adviserinfo.sec.gov/"
	DEFAULT_PARSER = nil

	attr_reader :endpoint, :parser

	def initialize(config = {})
		@endpoint = config[:endpoint] || DEFAULT_ENDPOINT
		@parser = config[:parser] || DEFAULT_PARSER
		@history = History.new(config)
	end

	def get(id, opts = {})
    record = get_ia_representative(id) ||
      get_ia_firm(id) ||
      get_broker(id) ||
      get_broker_firm(id)
    raise RemoteRecordNotFound.new("Record #{id} not found")

    after_get(record)
  end

	def write(file_path, format = :csv)

	end

	def save

	end

	def history
		@history.list
	end

	private

  def get_ia_representative(id)
    remote_get(ia_representative_uri(id), IARepresentativeParser)
  end

  def get_ia_firm(id)
    remote_get(ia_firm_uri(id), IAFirmParser)
  end

  def get_broker(id)
    remote_get(broker_uri(id), BrokerParser)
  end

  def get_broker_firm(id)
    remote_get(broker_firm_uri(id), BrokerFirmParser)
  end

  def remote_get(uri, parser)
    resp = Net::HTTP.get_response(uri)
    raise RemoteServerError.new("There was a problem accessing the requested URI: #{uri}") if resp.nil?
    return if record_not_found(resp)
    parser.create(html)
  end

  def record_not_found(resp)
    resp.status != "200" || resp.body[/no result/i]
  end

  def after_get(object)
    @history.add(object)
    object # always return the object
  end

	def ia_representative_uri(id)
		"#{adviser_info_base_uri}/IAPDIndvlSummary.aspx?INDVL_PK=#{id}"
	end

  def ia_firm_uri(id)
    "#{adviser_info_base_uri}/IAPDFirmSummary.aspx?ORG_PK=#{id}"
  end

  def broker_uri(id)
    "#{brokercheck_base_uri}/Individual/Summary/#{id}"
  end

  def broker_firm_uri(id)
    "#{brokercheck_base_uri}/Firm/Summary/#{id}"
  end

  def brokercheck_base_uri
    "http://brokercheck.finra.org"
  end

  def adviser_info_base_uri
    "http://www.adviserinfo.sec.gov/IAPD"
  end

end