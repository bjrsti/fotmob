# frozen_string_literal: true

RSpec.describe Fotmob::Client do
  let(:client) { described_class.new }

  describe "#initialize" do
    it "sets default timeout to 10 seconds" do
      expect(client.timeout).to eq(10)
    end

    it "sets default timezone to Europe/Paris" do
      expect(client.timezone).to eq("Europe/Paris")
    end

    it "allows custom timeout" do
      custom_client = described_class.new(timeout: 30)
      expect(custom_client.timeout).to eq(30)
    end

    it "allows custom timezone" do
      custom_client = described_class.new(timezone: "America/New_York")
      expect(custom_client.timezone).to eq("America/New_York")
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

  describe "#get_matches", :vcr do
    it "returns leagues and date for a given date" do
      result = client.get_matches("20260516")

      expect(result).to be_a(Hash)
      expect(result).to have_key(:leagues)
      expect(result).to have_key(:date)
      expect(result[:leagues]).to be_an(Array)
      expect(result[:leagues]).not_to be_empty
    end
  end

  describe "#get_match_details", :vcr do
    it "returns match details for the FA Cup Final (Chelsea vs Man City)" do
      result = client.get_match_details("5315746")

      expect(result).to be_a(Hash)
      expect(result).to have_key(:general)
      expect(result).to have_key(:header)
      expect(result).to have_key(:content)

      general = result[:general]
      expect(general[:matchId].to_i).to eq(5_315_746)
      expect(general[:leagueName]).to eq("FA Cup")
      expect(general[:homeTeam][:name]).to eq("Chelsea")
      expect(general[:awayTeam][:name]).to eq("Manchester City")

      expect(result[:header][:status][:finished]).to be true
      expect(result[:header][:status][:scoreStr]).to eq("0 - 1")
    end
  end

  describe "#get_league", :vcr do
    it "returns league data with symbolized keys" do
      result = client.get_league("47") # Premier League

      expect(result).to be_a(Hash)
      expect(result).to have_key(:details)
      expect(result[:details][:name]).to eq("Premier League")
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

    it "raises NotFoundError for unknown match ID" do
      allow_any_instance_of(Fotmob::Client).to receive(:fetch_with_timeout).and_raise(
        OpenURI::HTTPError.new("404 Not Found", double(status: ["404", "Not Found"], read: ""))
      )

      expect { client.get_match_details("0000000") }.to raise_error(Fotmob::NotFoundError)
    end
  end
end
