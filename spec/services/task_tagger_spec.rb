require 'rails_helper'

describe TaskTagger do
  subject { TaskTagger.new.perform(tasks, tags) }

  describe '#perform' do
    it 'adds tags to tasks' do
    end
  end
end
