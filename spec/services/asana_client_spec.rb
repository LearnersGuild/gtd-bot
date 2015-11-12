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

  describe "#project" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:project)
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
end
