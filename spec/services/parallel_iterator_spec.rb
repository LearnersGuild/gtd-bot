require 'rails_helper'

describe ParallelIterator do
  let(:parallel_iterator) { ParallelIterator.new }
  let(:collection) { [1, 2, 3] }
  let(:block) { proc {} }

  describe '#each' do
    subject { parallel_iterator.each(collection, &block) }

    it 'calls Parallel.each with block' do
      expect(Parallel).to receive(:each)
        .with(collection, in_threads: ParallelIterator::THREADS_NUMBER, &block)
      subject
    end
  end

  describe '#map' do
    subject { parallel_iterator.map(collection, &block) }

    it 'calls Parallel.each with block' do
      expect(Parallel).to receive(:map)
        .with(collection, in_threads: ParallelIterator::THREADS_NUMBER, &block)
      subject
    end
  end
end
