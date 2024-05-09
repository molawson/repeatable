shared_examples "a set expression" do
  let(:tuesday) { Repeatable::Expression::Weekday.new(weekday: 2) }
  let(:thursday) { Repeatable::Expression::Weekday.new(weekday: 4) }
  let(:tenth) { Repeatable::Expression::DayInMonth.new(day: 10) }
  let(:another_tuesday) { Repeatable::Expression::Weekday.new(weekday: 2) }

  describe "#<<" do
    it "returns the set object" do
      expect(subject << tenth).to be_a(described_class)
    end

    context "no existing elements" do
      subject { described_class.new }

      it "adds the new element to the array" do
        subject << tenth
        expect(subject.send(:elements)).to eq([tenth])
      end
    end

    context "existing elements" do
      subject { described_class.new(tuesday, thursday) }

      it "appends the new element to the elements array" do
        subject << tenth
        expect(subject.send(:elements)).to eq([tuesday, thursday, tenth])
      end

      it "will not add a duplicate of an existing element" do
        expect { subject << another_tuesday }.not_to change { subject.send(:elements) }
      end
    end
  end

  describe "#to_h" do
    it "returns to_h representation of included elements" do
      set = described_class.new([tuesday, tenth, thursday])
      expect(set.to_h.values.first).to eq([tuesday.to_h, tenth.to_h, thursday.to_h])
    end
  end

  describe "#==" do
    let(:set_one) { described_class.new([tuesday, tenth, thursday]) }
    let(:set_two) { described_class.new([tuesday, tenth]) }
    let(:set_three) { described_class.new([tuesday, thursday]) }
    let(:set_another_one) { described_class.new([tuesday, tenth, thursday]) }
    let(:set_reordered_one) { described_class.new([tenth, tuesday, thursday]) }

    it "returns true if both sets have the same identity" do
      expect(set_one).to eq(set_one)
    end

    it "returns true if both sets contain the same elements" do
      expect(set_one).to eq(set_another_one)
    end

    it "returns true if both sets contain the same elements regardless of order" do
      expect(set_one).to eq(set_reordered_one)
    end

    it "returns false if both sets do not contain the same elements" do
      expect(set_one).not_to eq(set_two)
      expect(set_two).not_to eq(set_one)
      expect(set_two).not_to eq(set_three)
      expect(set_three).not_to eq(set_two)
    end
  end
end
