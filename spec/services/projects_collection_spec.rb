require 'rails_helper'

describe ProjectsCollection do
  let(:collection) { ProjectsCollection.new(projects) }
  let(:projects) do
    [
      project_with_tasks,
      project_without_tasks,
      role,
      individual_project,
      with_role
    ]
  end
  let(:project_with_tasks) do
    ProjectObject.new(name: "Test1", asana_id: 7, tasks: tasks)
  end
  let(:tasks) { [TaskObject.new] }
  let(:project_without_tasks) { ProjectObject.new(name: "Test2", asana_id: 8) }
  let(:role) { ProjectObject.new(name: "&Test3", asana_id: 9) }
  let(:individual_project) { ProjectObject.new(name: "&Individual") }
  let(:role_link) { 'https://app.asana.com/0/7777/8888' }
  let(:with_role) { ProjectObject.new(description: "#{role_link} description") }
  let(:project) { ProjectObject.new(asana_id: '1111') }

  describe '#without_roles_and_tasks' do
    subject { collection.without_roles.without_tasks }

    before do
      expect(role).to receive(:a_role?).and_return(true)
    end

    it 'returns projects without tasks' do
      expected = ProjectsCollection.new([project_without_tasks, with_role])
      expect(subject).to eq(expected)
    end

    it 'does not return projects which are roles' do
      expect(subject).not_to include(role)
    end
  end

  shared_examples_for "with_tasks" do
    it 'returns projects without tasks' do
      expected = ProjectsCollection.new([project_with_tasks])
      expect(subject).to eq(expected)
    end
  end

  describe '#without_roles_with_tasks' do
    subject { collection.without_roles.with_tasks }

    before do
      expect(role).to receive(:a_role?).and_return(true)
    end

    it_behaves_like "with_tasks"

    it 'does not return projects which are roles' do
      expect(subject).not_to include(role)
    end
  end

  describe '#with tasks' do
    subject { collection.with_tasks }

    it_behaves_like "with_tasks"
  end

  describe '#individual' do
    subject { collection.individual }

    it 'returns projects with tasks' do
      expected = ProjectsCollection.new([individual_project])
      expect(subject).to eq(expected)
    end
  end

  describe '#roles' do
    subject { collection.roles }

    it 'returns projects with tasks' do
      expected = ProjectsCollection.new([role, individual_project])
      expect(subject).to eq(expected)
    end
  end

  describe '#without_roles_assigned' do
    subject { collection.without_roles_assigned }

    it 'returns projects without roles' do
      project = instance_double('ProjectObject', linked_role_ids: [])
      expected = ProjectsCollection.new([project])
      expect(collection).to receive(:without_roles)
        .and_return(expected)
      expect(subject).to eq(expected)
    end
  end

  describe "#create" do
    subject { collection.create(project) }
    let(:projects) { [] }

    it "adds projects to the list" do
      subject
      expect(collection.projects).to eq([project])
    end
  end

  describe "#update" do
    subject { collection.update(project) }

    it "deletes project from the list and creates new one" do
      expect(collection).to receive(:delete).with(project)
      expect(collection).to receive(:create).with(project)
      subject
    end
  end

  describe "#delete" do
    subject { collection.delete(project) }
    let(:projects) { [ProjectObject.new(asana_id: '1111', name: 'Name')] }

    it "deletes project from the list" do
      subject
      expect(collection.projects).to eq([])
    end
  end
end
