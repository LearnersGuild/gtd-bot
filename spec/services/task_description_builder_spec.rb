require 'rails_helper'

describe TaskDescriptionBuilder do
  let(:builder) { TaskDescriptionBuilder.new(description_parser) }
  let(:description_parser) do
    instance_double('DescriptionParser')
  end
  let(:role) { 'https://app.asana.com/0/7777/role' }

  describe "#with_project_roles" do
    subject { builder.with_project_roles(task, project) }
    let(:task) { TaskObject.new }
    let(:project) { ProjectObject.new }

    it "joins existing description and built roles" do
      expect(description_parser).to receive(:plain_description)
        .and_return('Task Description')
      expect(builder).to receive(:build_roles).with(task, project)
        .and_return([role])

      expect(subject).to eq("#{role} Task Description")
    end
  end

  describe "#build_roles" do
    subject { builder.build_roles(task, project) }
    let(:task) { TaskObject.new(description: 'mock task description') }
    let(:project) { ProjectObject.new(description: 'mock project description') }
    let(:task_role) { 'https://app.asana.com/0/7777/task' }
    let(:project_role) { 'https://app.asana.com/0/7777/project' }
    let(:task_roles) { [task_role, role] }
    let(:project_roles) { [project_role] }
    let(:prefix_roles) { task_roles }

    before do
      expect(description_parser).to receive(:all_roles)
        .with(task.description).and_return(task_roles)
      expect(description_parser).to receive(:all_roles)
        .with(project.description).and_return(project_roles)
      expect(description_parser).to receive(:prefix_roles)
        .with(task.description).and_return(prefix_roles)
    end

    it { expect(subject).to eq([project_role, task_role, role]) }

    context "task role as a part of description sentence" do
      let(:task_roles) { [task_role, role] }
      let(:project_roles) { [project_role] }
      let(:prefix_roles) { [task_role] }

      it { expect(subject).to eq([project_role, task_role]) }
    end

    context "no task roles" do
      let(:task_roles) { [] }
      let(:project_roles) { [project_role] }
      let(:prefix_roles) { [] }

      it { expect(subject).to eq([project_role]) }
    end

    context "no project roles" do
      let(:task_roles) { [task_role, role] }
      let(:project_roles) { [] }
      let(:prefix_roles) { task_roles }

      it { expect(subject).to eq([task_role, role]) }

      context "task role as a part of description sentence" do
        let(:task_roles) { [task_role, role] }
        let(:prefix_roles) { [task_role] }

        it { expect(subject).to eq([task_role]) }
      end

      context "no task roles" do
        let(:task_roles) { [] }
        let(:prefix_roles) { [] }

        it { expect(subject).to eq([]) }

        context "task role as a part of description sentence" do
          let(:task_roles) { [role] }
          let(:prefix_roles) { [] }

          it { expect(subject).to eq([]) }
        end
      end
    end
  end
end
