require 'rails_helper'

describe ProjectsFilter do
  let(:project_filter) { ProjectsFilter.new(projects) }
  let(:projects) do
    [project_with_tasks, project_without_tasks]
  end
  let(:project_with_tasks) { ProjectObject.new(asana_id: 7, tasks: tasks) }
  let(:tasks) { [TaskObject.new] }
  let(:project_without_tasks) { ProjectObject.new(asana_id: 8) }

  describe '#without tasks' do
    subject { project_filter.without_tasks }

    it 'returns projects without tasks' do
      expect(subject).to eq([project_without_tasks])
    end
  end
end
