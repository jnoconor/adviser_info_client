require 'pry'
require 'open-uri'
require 'net/http'
require_relative './history'
require_relative './errors'
Dir[File.expand_path("../services/**/*.rb", __FILE__)].each { |f| require f }
Dir[File.expand_path("../models/**/*.rb", __FILE__)].each { |f| require f }
Dir[File.expand_path("../database/**/*.rb", __FILE__)].each { |f| require f }

module AdviserInfo
  class Client

  	DEFAULT_ENDPOINT = "http://www.adviserinfo.sec.gov/"

  	attr_reader :endpoint, :file_path, :db_adapter

  	def initialize(config = {})
  		@endpoint = config[:endpoint] || DEFAULT_ENDPOINT
      @db_adapter = DatabaseAdapter.connect(config[:database]) # returns nil if no config
  		@history = History.new(config)
  	end

    def get(id, opts = {})
      validate_opts(opts)
      if id.respond_to? :each
        id.each do |id|
          begin
            get_one(id, opts)
          rescue AdviserInfo::RemoteRecordNotFound => e
            puts e
          end
        end
      else
        get_one(id, opts)
      end
    end

  	def get_one(id, opts = {})
      record = send("get_ia_#{opts[:type]}", id) || send("get_broker_#{opts[:type]}", id)
      raise AdviserInfo::RemoteRecordNotFound.new("Record #{id} for #{opts[:type]} not found") if record.nil?

      after_get(record)
    end

  	def write_all(file_path, format = :csv)
      raise "File path not provided" unless file_path
      history.list.each { |r| r[:object].write(file_path, format) }
  	end

  	def save_all
      raise "Database not configured" unless db_adapter
      history.list.each { |r| r[:object].save }
  	end

  	def history
  		@history.list
  	end

  	private

    def validate_opts(opts)
      valid = [:firm, :rep]
      unless valid.include?(opts[:type])
        raise AdviserInfo::InvalidOptions.new("Type #{opts[:type]} is invalid. Valid types are #{valid}")
      end
    end

    def get_ia_rep(id)
      remote_get(ia_representative_uri(id), IARepresentativeParser)
    end

    def get_ia_firm(id)
      remote_get(ia_firm_uri(id), IAFirmParser)
    end

    def get_broker_rep(id)
      remote_get(broker_uri(id), BrokerParser)
    end

    def get_broker_firm(id)
      remote_get(broker_firm_uri(id), BrokerFirmParser)
    end

    def remote_get(uri, parser)
      resp = Net::HTTP.get_response(uri)
      raise AdviserInfo::RemoteServerError.new("There was a problem accessing the requested URI: #{uri}") if resp.nil?
      return if record_not_found(resp)
      parser.create(resp.body, db_adapter)
    end

    def record_not_found(resp)
      resp.code != "200" || resp.body[/no result/i]
    end

    def after_get(object)
      @history.add(object)
      object # always return the object
    end

  	def ia_representative_uri(id)
  		URI("#{adviser_info_base_uri}/IAPDIndvlSummary.aspx?INDVL_PK=#{id}")
  	end

    def ia_firm_uri(id)
      URI("#{adviser_info_base_uri}/IAPDFirmSummary.aspx?ORG_PK=#{id}")
    end

    def broker_uri(id)
      URI("#{brokercheck_base_uri}/Individual/Summary/#{id}")
    end

    def broker_firm_uri(id)
      URI("#{brokercheck_base_uri}/Firm/Summary/#{id}")
    end

    def brokercheck_base_uri
      "http://brokercheck.finra.org"
    end

    def adviser_info_base_uri
      "http://www.adviserinfo.sec.gov/IAPD"
    end

  end
end