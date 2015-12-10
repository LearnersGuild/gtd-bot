class ParallelIterator < BaseService
  THREADS_NUMBER = 100

  def each(array, &block)
    Parallel.each(array, in_threads: THREADS_NUMBER, &block)
  end

  def map(array, &block)
    Parallel.map(array, in_threads: THREADS_NUMBER, &block)
  end
end
