require 'rails_helper'

describe StrategiesFactory do
  let(:strategies_factory) do
    StrategiesFactory.new(asana_hierarchy_fetcher, asana_client)
  end
  let(:asana_client) do
    instance_double('AsanaClient')
  end
  let(:asana_hierarchy_fetcher) do
    instance_double('AsanaHierarchyFetcher', projects: projects)
  end
  let(:projects) { [ProjectObject.new] }

  describe "#create" do
    subject { strategies_factory.create(team) }
    let(:team) { TeamObject.new }

    it "creates strategies" do
      expect(asana_hierarchy_fetcher).to receive(:projects).with(team)
      expect(ProjectsCollection).to receive(:new).with(projects)
      expect(subject).not_to be_empty
    end
  end
end
