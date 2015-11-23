require 'rails_helper'

describe ProjectsFilter do
  let(:projects_filter) { ProjectsFilter.new(projects) }
  let(:projects) do
    [
      project_with_tasks,
      project_without_tasks,
      role,
      underscored,
      individual_project,
      with_role
    ]
  end
  let(:project_with_tasks) do
    ProjectObject.new(name: "Test1", asana_id: 7, tasks: tasks)
  end
  let(:tasks) { [TaskObject.new] }
  let(:project_without_tasks) { ProjectObject.new(name: "Test2", asana_id: 8) }
  let(:role) { ProjectObject.new(name: "@Test3", asana_id: 9) }
  let(:individual_project) { ProjectObject.new(name: "@Individual") }
  let(:underscored) { ProjectObject.new(name: "_Test") }
  let(:role_link) { 'https://app.asana.com/0/7777/8888' }
  let(:with_role) { ProjectObject.new(description: "#{role_link} description") }
  let(:project) { ProjectObject.new(asana_id: '1111') }

  describe '#without tasks' do
    subject { projects_filter.without_tasks }

    before do
      expect(role).to receive(:a_role?).and_return(true)
    end

    it 'returns projects without tasks' do
      expect(subject).to eq([project_without_tasks, with_role])
    end

    it 'does not return projects which are roles' do
      expect(subject).not_to include(role)
    end
  end

  describe '#with tasks' do
    subject { projects_filter.with_tasks }

    it 'returns projects with tasks' do
      expect(subject).to eq([project_with_tasks])
    end
  end

  describe '#individual' do
    subject { projects_filter.individual }

    it 'returns projects with tasks' do
      expect(subject).to eq([individual_project])
    end
  end

  describe '#roles' do
    subject { projects_filter.roles }

    it 'returns projects with tasks' do
      expect(subject).to eq([role, individual_project])
    end
  end

  describe '#without_roles_assigned' do
    subject { projects_filter.without_roles_assigned }

    it 'returns projects without roles' do
      expected_projects = [project_with_tasks, project_without_tasks]
      expect(subject).to eq(expected_projects)
    end
  end

  describe "#create" do
    subject { projects_filter.create(project) }
    let(:projects) { [] }

    it "adds projects to the list" do
      subject
      expect(projects_filter.projects).to eq([project])
    end
  end

  describe "#update" do
    subject { projects_filter.update(project) }

    it "deletes project from the list and creates new one" do
      expect(projects_filter).to receive(:delete).with(project)
      expect(projects_filter).to receive(:create).with(project)
      subject
    end
  end

  describe "#delete" do
    subject { projects_filter.delete(project) }
    let(:projects) { [ProjectObject.new(asana_id: '1111', name: 'Name')] }

    it "deletes project from the list" do
      subject
      expect(projects_filter.projects).to eq([])
    end
  end
end
