# frozen_string_literal: true

RSpec.describe Fotmob::Client, :integration do
  let(:client) { described_class.new }

  describe "#get_team" do
    it "returns a hash with team details" do
      result = client.get_team("8540") # Palermo

      expect(result).to be_a(Hash)
      expect(result).to have_key(:details)
      expect(result[:details]).to have_key(:id)
      expect(result[:details]).to have_key(:name)
    end
  end

  describe "#get_matches" do
    it "returns leagues for today" do
      date = Time.now.strftime("%Y%m%d")
      result = client.get_matches(date)

      expect(result).to be_a(Hash)
      expect(result).to have_key(:leagues)
      expect(result[:leagues]).to be_an(Array)
    end
  end

  describe "#get_league" do
    it "returns Premier League details" do
      result = client.get_league("47") # Premier League

      expect(result).to be_a(Hash)
      expect(result).to have_key(:details)
      expect(result[:details]).to have_key(:name)
    end
  end

  describe "#get_match_details" do
    it "returns match data with expected top-level keys" do
      # FA Cup Final 2025 — Chelsea vs Man City, a finished match
      result = client.get_match_details("5315746")

      expect(result).to be_a(Hash)
      expect(result).to have_key(:general)
      expect(result).to have_key(:header)
      expect(result).to have_key(:content)
    end
  end
end
