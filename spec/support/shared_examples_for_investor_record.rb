RSpec.shared_examples "investor record" do

  it "defines FIELDS" do
    expect(described_class::FIELDS).to_not be_empty
  end

  it "can be instantiated with a hash of information" do
    expect(described_class.new({})).to be_instance_of described_class
  end

  describe "#write" do

    context "when the format is :csv" do
      it "writes the #{described_class} data to a row in a CSV file" do

      end
    end

    context "when the format is :json" do
      it "write the #{described_class} data to JSON in a file" do

      end
    end

  end

end