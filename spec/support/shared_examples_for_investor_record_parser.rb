RSpec.shared_examples "investor record parser" do |target_class|
  let(:basic_html) { "<html><body>text</body></html>"}

  before(:all) do
    fixture_html = File.open(File.expand_path("../../fixtures/#{target_class}.html", __FILE__))
    @target_class_instance = described_class.create(fixture_html)
  end

  it "returns an instance of #{target_class}" do
    expect(described_class.create(basic_html)).to be_instance_of(target_class)
  end

  target_class::FIELDS.each do |attribute|
    it "assigns the #{attribute} to the #{target_class}" do
      expect(@target_class_instance.send(attribute)).to_not be_nil
    end
  end

end