require 'rails_helper'

describe StrategiesFactory do
  let(:strategies_factory) do
    StrategiesFactory.new(asana_hierarchy_fetcher, asana_client)
  end
  let(:asana_client) do
    instance_double('AsanaClient', all_tags: [])
  end
  let(:asana_hierarchy_fetcher) do
    instance_double('AsanaHierarchyFetcher', projects: projects)
  end
  let(:projects) { [ProjectObject.new] }
  let(:collection) { double(:collection) }

  describe "#create" do
    subject { strategies_factory.create(team) }
    let(:team) { TeamObject.new }

    it "creates strategies" do
      expect(asana_hierarchy_fetcher).to receive(:projects).with(team)
      expect(ProjectsCollection).to receive(:new).with(projects)
        .and_return(collection)
      expect(ProjectsRepository).to receive(:new).with(asana_client, collection)
      expect(subject).not_to be_empty
    end
  end
end
