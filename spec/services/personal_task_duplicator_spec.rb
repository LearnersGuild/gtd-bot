require 'rails_helper'

describe PersonalTaskDuplicator do
  let(:service) { PersonalTaskDuplicator.new(tasks_repository, team, project) }
  let(:tasks_repository) do
    double("TasksRepository",
           uncompleted_tasks: tasks,
           create: double,
           delete: true)
  end
  let(:tasks) { [task] }
  let(:task) do
    TaskObject.new(asana_id: task_asana_id,
                   name: name,
                   tags: tags,
                   due_at: due_at,
                   due_on: due_on,
                   project_ids: project_ids)
  end
  let(:name) { 'test' }
  let(:tags) { [tag] }
  let(:tag) { TagObject.new(asana_id: '222') }
  let(:due_at) { double }
  let(:due_on) { nil }
  let(:project_ids) { [project.asana_id, another_project.asana_id] }
  let(:project) { ProjectObject.new(asana_id: '9999') }
  let(:another_project) { ProjectObject.new(asana_id: '8888') }
  let(:task_asana_id) { '111' }
  let(:team) { TeamObject.new(users: users) }
  let(:users) { [user] }
  let(:user) { UserObject.new(email: "test@test.com", asana_id: user_asana_id) }
  let(:user_asana_id) { '333' }
  let(:expected_task_attributes) do
    {
      name: name,
      tags: [tag.asana_id],
      assignee: user_asana_id,
      due_at: due_at,
      due_on: due_on,
      projects: [another_project.asana_id]
    }
  end

  describe '#perform' do
    subject { service.perform }

    it 'duplicates tasks to team members' do
      expect(tasks_repository).to receive(:uncompleted_tasks)
      expect(tasks_repository).to receive(:create)
        .with(nil, expected_task_attributes)
      expect(tasks_repository).to receive(:delete).with(task_asana_id)

      subject
    end
  end
end
