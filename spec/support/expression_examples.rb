# typed: false
shared_examples "an expression" do
  describe "#include?" do
    it "must be implemented" do
      expect { subject.include?(Date.new(2015, 1, 1)) }.not_to raise_error
    end
  end

  describe "#to_h" do
    it "must be implemented" do
      expect { subject.to_h }.not_to raise_error
    end
  end

  describe "pattern matching" do
    it "can #deconstruct_keys" do
      expect(subject.deconstruct_keys(nil)).to be_a(Hash)
    end
  end
end
