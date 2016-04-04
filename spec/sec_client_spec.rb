
RSpec.describe SecClient do
  let(:client) { SecClient.new }

  before do
  end

  it "exists" do
    expect(described_class.new).to_not be_nil
  end

  describe "#get" do

    context "when the CRD refers to an IA Representative" do
      let(:id) { 4815893 }
      it "returns an IARepresentative" do
        expect(client.get(id)).to be_instance_of(IARepresentative)
      end
    end

    context "when the CRD belongs to an IA Firm" do
      it "returns an IAFirm" do
        expect(client.get(id)).to be_instance_of(IAFirm)
      end
    end

    context "when the CRD belongs to a Broker" do
      it "returns an Broker" do
        expect(client.get(id)).to be_instance_of(Broker)
      end
    end

    context "when the CRD belongs to a BrokerFirm" do
      it "returns an BrokerFirm" do
        expect(client.get(id)).to be_instance_of(BrokerFirm)
      end
    end
  end

end