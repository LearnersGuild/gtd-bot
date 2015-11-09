require 'rails_helper'

describe AsanaClient do
  describe "#update" do
    it "delegates to Asana::Client" do
      expect(subject).to respond_to(:update)
    end
  end
end
