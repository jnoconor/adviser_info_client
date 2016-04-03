require_relative './support/shared_examples_for_investor_record_parser'

RSpec.describe IAFirmParser do
  xdescribe ".create" do

    it_behaves_like 'investor record parser', described_class.send(:target_class)

  end
end