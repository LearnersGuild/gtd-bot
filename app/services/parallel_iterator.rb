require 'memory_profiler'

class ParallelIterator < BaseService
  THREADS_NUMBER = 100
  PROFILER_OUTPUT_PATH = Rails.root.join("tmp", "memory_profile.txt")

  def each(array, &block)
    Parallel.each(array, in_threads: 100) do |project|
      profile_memory(project, &block)
    end
  end

  def map(array, &block)
    Parallel.map(array, in_threads: 100) do |project|
      profile_memory(project, &block)
    end
  end

  private

  def profile_memory(project, &block)
    block_result = nil
    report = MemoryProfiler.report do
      block_result = block.call(project)
    end

    File.open(PROFILER_OUTPUT_PATH, "a") do |f|
      report.pretty_print(f)
    end

    block_result
  end

  def self.check_results
    File.open(PROFILER_OUTPUT_PATH) do |f|
      content = f.read
      content.split("\n").map do |line|
        matched = line.match(/Total allocated: (\d+)/)
        matched && matched[1].to_i / 1024.0 / 1024.0
      end
    end.compact
  end
end
