require_relative './support/shared_examples_for_investor_record_parser'

RSpec.describe IARepresentativeParser do
  describe ".create" do

    it_behaves_like 'investor record parser', IARepresentative

  end
end