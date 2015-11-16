require 'rails_helper'

describe ProjectsFilter do
  let(:project_filter) { ProjectsFilter.new(projects) }
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

  describe '#without tasks' do
    subject { project_filter.without_tasks }

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
    subject { project_filter.with_tasks }

    it 'returns projects with tasks' do
      expect(subject).to eq([project_with_tasks])
    end
  end

  describe '#individual' do
    subject { project_filter.individual }

    it 'returns projects with tasks' do
      expect(subject).to eq([individual_project])
    end
  end

  describe '#roles' do
    subject { project_filter.roles }

    it 'returns projects with tasks' do
      expect(subject).to eq([role, individual_project])
    end
  end

  describe '#without_roles' do
    subject { project_filter.without_roles }

    it 'returns projects without roles' do
      expected_projects = projects - [underscored, with_role]
      expect(subject).to eq(expected_projects)
    end
  end
end
