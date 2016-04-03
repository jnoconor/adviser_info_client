RSpec.shared_examples "investor record" do

  it "defines FIELDS" do
    expect(described_class::FIELDS).to_not be_empty
  end

  it "can be instantiated with a hash of information" do
    expect(described_class.new({})).to be_instance_of described_class
  end

end