require 'rails_helper'

describe ProjectsFilter do
  let(:project_filter) { ProjectsFilter.new(projects) }
  let(:projects) do
    [project_with_tasks, project_without_tasks, role]
  end
  let(:project_with_tasks) { ProjectObject.new(asana_id: 7, tasks: tasks) }
  let(:tasks) { [TaskObject.new] }
  let(:project_without_tasks) { ProjectObject.new(asana_id: 8) }
  let(:role) { ProjectObject.new(asana_id: 9) }

  describe '#without tasks' do
    subject { project_filter.without_tasks }

    before do
      expect(role).to receive(:a_role?).and_return(true)
    end

    it 'returns projects without tasks' do
      expect(subject).to eq([project_without_tasks])
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
end
