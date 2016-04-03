require_relative '../lib/client'

RSpec.describe SecClient do

	it "exists" do
		expect(SecClient.new).to_not be_nil
	end

end