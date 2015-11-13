require 'rails_helper'

describe TaskDescriptionBuilder do
  let(:builder) { TaskDescriptionBuilder.new(description_parser) }
  let(:description_parser) do
    instance_double('DescriptionParser')
  end

  describe "#with_project_roles" do
    subject { builder.with_project_roles(task, project) }
    let(:task) { TaskObject.new }
    let(:project) { ProjectObject.new }

    it "joins existing description and task roles with project roles" do
      expect(description_parser).to receive(:plain_description)
        .and_return('Task Description')
      expect(description_parser).to receive(:roles).with(task.description)
        .and_return(['@Task Role'])
      expect(description_parser).to receive(:roles).with(project.description)
        .and_return(['@Project Role'])

      expect(subject).to eq("@Project Role @Task Role Task Description")
    end
  end
end
