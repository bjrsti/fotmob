# frozen_string_literal: true

RSpec.describe Fotmob do
  describe ".new" do
    it "creates a new Client instance" do
      client = Fotmob.new
      expect(client).to be_a(Fotmob::Client)
    end

    it "passes options to the Client" do
      client = Fotmob.new(timeout: 20)
      expect(client.timeout).to eq(20)
    end
  end

  describe "::VERSION" do
    it "has a version number" do
      expect(Fotmob::VERSION).not_to be_nil
      expect(Fotmob::VERSION).to match(/\d+\.\d+\.\d+/)
    end
  end
end
