# frozen_string_literal: true

RSpec.describe Fotmob::Client do
  let(:client) { described_class.new }

  describe "#initialize" do
    it "sets default timeout to 10 seconds" do
      expect(client.timeout).to eq(10)
    end

    it "allows custom timeout" do
      custom_client = described_class.new(timeout: 30)
      expect(custom_client.timeout).to eq(30)
    end
  end

  describe "#get_team", :vcr do
    it "returns team data with symbolized keys" do
      result = client.get_team("8540") # Palermo

      expect(result).to be_a(Hash)
      expect(result).to have_key(:details)
      expect(result[:details]).to have_key(:id)
      expect(result[:details]).to have_key(:name)
      expect(result[:details][:id]).to eq(8540)
    end
  end

  # NOTE: /matches endpoint appears to be deprecated/broken in the API
  # Keeping the method for backward compatibility but skipping test
  describe "#get_matches" do
    xit "returns matches for a given date" do
      result = client.get_matches("20250114")
      expect(result).to be_a(Hash)
    end
  end

  describe "#get_match_details", :vcr do
    it "returns match details with symbolized keys" do
      result = client.get_match_details("4193741") # Example match ID

      expect(result).to be_a(Hash)
      expect(result).to have_key(:general)
      expect(result[:general]).to have_key(:matchId)
    end
  end

  describe "#get_player", :vcr do
    it "returns player data with symbolized keys" do
      result = client.get_player("961995") # Example: Mbappe

      expect(result).to be_a(Hash)
      expect(result).to have_key(:id)
      expect(result).to have_key(:name)
    end
  end

  describe "#get_league", :vcr do
    it "returns league data with symbolized keys" do
      result = client.get_league("47") # Premier League

      expect(result).to be_a(Hash)
      expect(result).to have_key(:details)
    end
  end

  describe "error handling" do
    it "raises TimeoutError on timeout" do
      allow_any_instance_of(Fotmob::Client).to receive(:fetch_with_timeout)
        .and_raise(Fotmob::TimeoutError, "Request timed out")

      expect { client.get_team("8540") }.to raise_error(Fotmob::TimeoutError)
    end

    it "raises InvalidResponseError on malformed JSON" do
      allow_any_instance_of(Fotmob::Client).to receive(:fetch_with_timeout)
        .and_return("not valid json")

      expect { client.get_team("8540") }.to raise_error(Fotmob::InvalidResponseError)
    end
  end
end
