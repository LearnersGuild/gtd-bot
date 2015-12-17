require 'rails_helper'

describe PersonalTaskDuplicator do
  let(:service) do
    PersonalTaskDuplicator.new(tasks_repository,
                               parallel_iterator,
                               team, project)
  end
  let(:parallel_iterator) { ParallelIterator.new }
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
                   project_ids: project_ids,
                   follower_ids: followers,
                   description: description)
  end
  let(:name) { 'test' }
  let(:tags) { [tag] }
  let(:tag) { TagObject.new(asana_id: '222') }
  let(:project_ids) { [project.asana_id, another_project.asana_id] }
  let(:project) { ProjectObject.new(asana_id: '9999') }
  let(:another_project) { ProjectObject.new(asana_id: '8888') }
  let(:followers) { ['9999'] }
  let(:task_asana_id) { '111' }
  let(:team) { TeamObject.new(users: users) }
  let(:users) { [user] }
  let(:user) { UserObject.new(email: "test@test.com", asana_id: user_asana_id) }
  let(:user_asana_id) { '333' }
  let(:description) { 'test' }

  describe '#perform' do
    subject { service.perform }

    context 'with due_on and due_at' do
      let(:due_at) { double }
      let(:due_on) { double }
      let(:expected_task_attributes) do
        {
          name: name,
          tags: [tag.asana_id],
          assignee: user_asana_id,
          due_at: due_at,
          projects: [another_project.asana_id],
          followers: followers,
          notes: description
        }
      end

      it 'duplicates tasks to team members' do
        expect(tasks_repository).to receive(:uncompleted_tasks)
        expect(tasks_repository).to receive(:create)
          .with(nil, expected_task_attributes)
        expect(tasks_repository).to receive(:delete).with(task_asana_id)

        subject
      end

      context 'any task creation failed' do
        let(:users) { [user, other_user] }
        let(:other_user) { UserObject.new }

        it 'does not delete original task' do
          expect(tasks_repository).to receive(:uncompleted_tasks)
          expect(tasks_repository).to receive(:create)
            .and_return(true, false)
          expect(tasks_repository).not_to receive(:delete).with(task_asana_id)

          subject
        end
      end
    end

    context 'without due_at' do
      let(:due_at) { nil }
      let(:due_on) { double }
      let(:expected_task_attributes) do
        {
          name: name,
          tags: [tag.asana_id],
          assignee: user_asana_id,
          due_on: due_on,
          projects: [another_project.asana_id],
          followers: followers,
          notes: description
        }
      end

      it 'duplicates tasks to team members' do
        expect(tasks_repository).to receive(:uncompleted_tasks)
        expect(tasks_repository).to receive(:create)
          .with(nil, expected_task_attributes)
        expect(tasks_repository).to receive(:delete).with(task_asana_id)

        subject
      end
    end

    context 'without due_at and due_on' do
      let(:due_at) { nil }
      let(:due_on) { nil }
      let(:expected_task_attributes) do
        {
          name: name,
          tags: [tag.asana_id],
          assignee: user_asana_id,
          projects: [another_project.asana_id],
          followers: followers,
          notes: description
        }
      end

      it 'duplicates tasks to team members' do
        expect(tasks_repository).to receive(:uncompleted_tasks)
        expect(tasks_repository).to receive(:create)
          .with(nil, expected_task_attributes)
        expect(tasks_repository).to receive(:delete).with(task_asana_id)

        subject
      end
    end
  end
end
