require_relative './support/shared_examples_for_investor_record_parser'

RSpec.describe BrokerFirmParser do

  it_behaves_like 'investor record parser', BrokerFirm

end