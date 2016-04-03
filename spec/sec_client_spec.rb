
RSpec.describe SecClient do
  let(:client) { SecClient.new }
  let(:id) { 4815893 }

  before do
  end

  it "exists" do
    expect(described_class.new).to_not be_nil
  end

  describe "#get" do
    it "returns an IARepresentative" do
      expect(client.get(id)).to be_instance_of(IARepresentative)
    end
  end

end