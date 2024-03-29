require 'rails_helper'

describe AsanaClient do
  subject { asana_client }
  let(:asana_client) { AsanaClient.new(factories_injector, exceptions_handler) }
  let(:client) { asana_client.client }
  let(:factories_injector) do
    FactoriesInjector.new(team_object_factory, project_object_factory,
                          task_object_factory, tag_object_factory,
                          user_object_factory, subtask_object_factory)
  end
  let(:exceptions_handler) do
    instance_double('ExceptionsHandler', context: nil, clear_context: nil)
  end

  let(:team_object_factory) do
    TeamObjectFactory.new(role_object_factory, user_object_factory)
  end
  let(:role_object_factory) do
    RoleObjectFactory.new(RoleLinksFactory.new, user_object_factory)
  end
  let(:task_object_factory) { TaskObjectFactory.new }
  let(:tag_object_factory) { TagObjectFactory.new }
  let(:project_object_factory) do
    instance_double('ProjectObjectFactory', build_from_asana: project_object)
  end
  let(:user_object_factory) { UserObjectFactory.new }
  let(:subtask_object_factory) { SubtaskObjectFactory.new }
  let(:project_object) do
    ProjectObject.new(asana_id: '7777', name: project_name)
  end
  let(:project_name) { 'Project name' }
  let(:attributes) { { name: project_name } }
  let(:asana_project) { double(:asana_project, id: '7777') }
  let(:asana_task) { double(:asana_task, id: '8888') }
  let(:workspace_id) { '1111' }

  describe "#create_project" do
    subject { asana_client.create_project(workspace_id, team_id, attributes) }
    let(:team_id) { '2222' }

    it "delegates to Asana::Client" do
      project_attributes = attributes.merge(
        workspace: workspace_id,
        team: team_id
      )
      expect(Asana::Project).to receive(:create)
        .with(client, project_attributes)
        .and_return(asana_project)
      expect(project_object_factory).to receive(:build_from_asana)
        .with(asana_project)
      expect(subject).to eq(project_object)
    end
  end

  describe "#delete_project" do
    subject { asana_client.delete_project('7777') }

    it "delegates to Asana::Client" do
      expect(Asana::Project).to receive(:new)
        .with({ id: '7777' }, { client: client })
        .and_return(asana_project)
      expect(asana_project).to receive(:delete).and_return(true)
      subject
    end
  end

  describe "#update_project" do
    subject { asana_client.update_project('7777', attributes) }

    it "delegates to Asana::Client" do
      expect(Asana::Project).to receive(:new)
        .with({ id: '7777' }, { client: client })
        .and_return(asana_project)
      expect(asana_project).to receive(:update).and_return(asana_project)
      expect(project_object_factory).to receive(:build_from_asana)
        .with(asana_project)
      expect(subject).to eq(project_object)
    end
  end

  describe "#teams" do
    subject { asana_client.teams('8888') }
    let(:asana_team) { double(:asana_team, users: users) }
    let(:users) { [double(id: id, email: email)] }
    let(:id) { '111' }
    let(:email) { 'test@test.com' }
    let(:team_object) { TeamObject.new }

    it "delegates to Asana::Client" do
      expect(Asana::Team).to receive(:find_by_organization)
        .and_return([asana_team])
      expect(team_object_factory).to receive(:from_asana)
        .with(asana_team, users).and_return(team_object)
      expect(subject).to eq([team_object])
    end
  end

  describe "#projects" do
    subject { asana_client.projects('8888', '9999') }

    it "delegates to Asana::Client" do
      expect(Asana::Project).to receive(:find_all).and_return([asana_project])
      expect(subject).to eq([project_object])
    end
  end

  describe "#create_task" do
    subject { asana_client.create_task(workspace_id, project_id, attributes) }
    let(:attributes) { { name: 'Task' } }

    context "project_id nil" do
      let(:project_id) { nil }

      it "executes Asana::Task.create with given attributes" do
        expect(Asana::Task).to receive(:create)
          .with(asana_client.client, name: 'Task', workspace: workspace_id)
          .and_return(asana_task)
        expect(task_object_factory).to receive(:build_from_asana)
          .with(asana_task)
        subject
      end
    end

    context "project_id present" do
      let(:project_id) { '7777' }

      shared_examples_for "executes Asana::Task.create" do
        it do
          expect(Asana::Task).to receive(:create)
            .with(asana_client.client, expected_attributes)
            .and_return(asana_task)
          expect(task_object_factory).to receive(:build_from_asana)
            .with(asana_task)
          subject
        end
      end

      context "attributes includes projects" do
        let(:attributes) { { name: 'Task', projects: ['8888'] } }
        let(:expected_attributes) do
          {
            workspace: workspace_id,
            name: 'Task',
            projects: %w{8888 7777}
          }
        end

        it_behaves_like "executes Asana::Task.create"
      end

      context "projects key not present in attributes" do
        let(:expected_attributes) do
          {
            workspace: workspace_id,
            name: 'Task',
            projects: ['7777']
          }
        end

        it_behaves_like "executes Asana::Task.create"
      end
    end
  end

  describe "#delete_task" do
    subject { asana_client.delete_task('8888') }

    it "delegates to Asana::Client" do
      expect(Asana::Task).to receive(:new)
        .with({ id: '8888' }, { client: client })
        .and_return(asana_task)
      expect(asana_task).to receive(:delete).and_return(true)
      subject
    end
  end

  describe "#tasks_for_project" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:tasks_for_project)
    end
  end

  describe "#update_task" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:update_task)
    end
  end

  describe "#update_subtask" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:update_subtask)
    end
  end

  describe "#add_project_to_task" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:add_project_to_task)
    end
  end

  describe "#all_tags" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:all_tags)
    end
  end

  describe "#add_tag_to_task" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:add_tag_to_task)
    end
  end

  describe "#create_tag" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:create_tag)
    end
  end
end
