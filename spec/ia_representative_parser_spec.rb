
RSpec.describe IARepresentativeParser do
  describe ".create" do
    let(:basic_html) { "<html><body>text</body></html>"}
    let(:fixture_html) { File.open(File.expand_path("../fixtures/ia_rep.html", __FILE__)) }
    let(:rep) { described_class.create(fixture_html) }

    it "returns an instance of IARepresentative" do
      expect(described_class.create(basic_html)).to be_instance_of(IARepresentative)
    end

    IARepresentative::ATTRS.each do |attribute|
      it "assigns the #{attribute} to the IARepresentative" do
        expect(rep.send(attribute)).to_not be_nil
      end
    end

  end
end