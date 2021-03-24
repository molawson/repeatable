require "spec_helper"

class DummyKlass
end

shared_examples "possible date conversion" do
  subject { Date(arg) }

  it "converts to expected date" do
    expect(subject).to be_a(Date)
    expect(subject).to eq(expected_result)
  end
end

shared_examples "impossible date conversion" do
  subject { Date(arg) }

  it "raises a TypeError" do
    expect { subject }.to raise_error(TypeError)
  end
end

describe DummyKlass do
  include Repeatable::Conversions

  let(:expected_result) { Date.new(2015, 1, 10) }

  context "Date" do
    it_behaves_like "possible date conversion" do
      let(:arg) { Date.new(2015, 1, 10) }
    end
  end

  context "DateTime" do
    it_behaves_like "possible date conversion" do
      let(:arg) { DateTime.new(2015, 1, 10, 12, 30, 0, "+6") }
    end
  end

  context "Time" do
    it_behaves_like "possible date conversion" do
      let(:arg) { Time.new(2015, 1, 10, 12, 30, 0, "+06:00") }
    end
  end

  context "String" do
    context "dash format" do
      it_behaves_like "possible date conversion" do
        let(:arg) { "2015-01-10" }
      end
    end

    context "numerical format" do
      it_behaves_like "possible date conversion" do
        let(:arg) { "20150110" }
      end
    end

    context "human format" do
      it_behaves_like "possible date conversion" do
        let(:arg) { "10th Jan 2015" }
      end
    end

    context "non date format" do
      it_behaves_like "impossible date conversion" do
        let(:arg) { "asdf" }
      end
    end
  end

  context "Integer" do
    it_behaves_like "impossible date conversion" do
      let(:arg) { 20150110 }
    end
  end
end
