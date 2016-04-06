
RSpec.describe AdviserInfo::Client do

  before do
    WebMock.disable_net_connect!
    @ia_representative_uri_stub = stub_request(:get, described_class.new.send(:ia_representative_uri, 1)).to_return({status: 302})
    @ia_firm_uri_stub = stub_request(:get, described_class.new.send(:ia_firm_uri, 1)).to_return({status: 302})
    @broker_uri_stub = stub_request(:get, described_class.new.send(:broker_uri, 1)).to_return({status: 302})
    @broker_firm_uri_stub = stub_request(:get, described_class.new.send(:broker_firm_uri, 1)).to_return({status: 302})
  end

  let(:client) { AdviserInfo::Client.new }
  let(:id) { 1 }

  it "exists" do
    expect(described_class.new).to_not be_nil
  end

  describe "#get" do

    context "when the CRD is invalid" do
      it "raises an error" do
        expect{ client.get(1, type: :firm) }.to raise_error(AdviserInfo::RemoteRecordNotFound)
      end
    end

    context "when the CRD belongs to an IA Representative" do
      before do
        fixture = load_fixture("IARepresentative")
        remove_request_stub(@ia_representative_uri_stub)
        stub_request(:get, described_class.new.send(:ia_representative_uri, 1)).to_return({status: 200, body: fixture})
      end

      it "returns an IARepresentative" do
        expect(client.get(1, type: :rep)).to be_instance_of(IARepresentative)
      end
    end

    context "when the CRD belongs to an IA Firm" do
      before do
        fixture = load_fixture("IAFirm")
        remove_request_stub(@ia_firm_uri_stub)
        stub_request(:get, described_class.new.send(:ia_firm_uri, 1)).to_return({status: 200, body: fixture})
      end

      it "returns an IAFirm" do
        expect(client.get(id, type: :firm)).to be_instance_of(IAFirm)
      end
    end

    context "when the CRD belongs to a Broker" do
      before do
        fixture = load_fixture("Broker")
        remove_request_stub(@broker_uri_stub)
        stub_request(:get, described_class.new.send(:broker_uri, 1)).to_return({status: 200, body: fixture})
      end

      it "returns a Broker" do
        expect(client.get(id, type: :rep)).to be_instance_of(Broker)
      end
    end

    context "when the CRD belongs to a BrokerFirm" do
      before do
        fixture = load_fixture("BrokerFirm")
        remove_request_stub(@broker_firm_uri_stub)
        stub_request(:get, described_class.new.send(:broker_firm_uri, 1)).to_return({status: 200, body: fixture})
      end

      it "returns a BrokerFirm" do
        expect(client.get(id, type: :firm)).to be_instance_of(BrokerFirm)
      end
    end
  end

end