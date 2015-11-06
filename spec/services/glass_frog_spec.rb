require 'rails_helper'

describe GlassFrog do
  describe "#roles" do
    it "delegates to Glassfrog client" do
      expect(subject).to respond_to(:roles)
    end
  end
end
