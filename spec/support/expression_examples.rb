shared_examples 'an expression' do
  describe '#include?' do
    it 'must be implemented' do
      expect { subject.include?(Date.new(2015, 1, 1)) }.not_to raise_error
    end
  end
end
