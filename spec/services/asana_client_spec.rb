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
end
