require 'rails_helper'

module Strategies
  describe EveryoneTask do
    let(:strategy) { EveryoneTask.new(projects_filter, asana_client) }
    describe '#perform' do
      subject { strategy.perform }
    end
  end
end
