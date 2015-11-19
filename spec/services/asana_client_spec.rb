require 'rails_helper'

describe AsanaClient do
  describe "#create_project" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:create_project)
    end
  end

  describe "#delete_project" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:delete_project)
    end
  end

  describe "#create_project" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:update_project)
    end
  end

  describe "#projects" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:projects)
    end
  end

  describe "#create_task" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:create_task)
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
