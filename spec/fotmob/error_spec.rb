# frozen_string_literal: true

RSpec.describe Fotmob::Error do
  it "is a StandardError" do
    expect(described_class.new).to be_a(StandardError)
  end
end

RSpec.describe Fotmob::APIError do
  describe "#initialize" do
    it "accepts message, status_code, and response_body" do
      error = described_class.new("Error message", status_code: 500, response_body: "error")

      expect(error.message).to eq("Error message")
      expect(error.status_code).to eq(500)
      expect(error.response_body).to eq("error")
    end

    it "is a Fotmob::Error" do
      expect(described_class.new("test")).to be_a(Fotmob::Error)
    end
  end
end

RSpec.describe Fotmob::NotFoundError do
  it "is an APIError" do
    error = described_class.new("Not found", status_code: 404, response_body: "")
    expect(error).to be_a(Fotmob::APIError)
    expect(error.status_code).to eq(404)
  end
end

RSpec.describe Fotmob::RateLimitError do
  it "is an APIError" do
    error = described_class.new("Rate limit", status_code: 429, response_body: "")
    expect(error).to be_a(Fotmob::APIError)
    expect(error.status_code).to eq(429)
  end
end

RSpec.describe Fotmob::TimeoutError do
  it "is a Fotmob::Error" do
    error = described_class.new("Timeout")
    expect(error).to be_a(Fotmob::Error)
  end
end

RSpec.describe Fotmob::InvalidResponseError do
  it "is a Fotmob::Error" do
    error = described_class.new("Invalid JSON")
    expect(error).to be_a(Fotmob::Error)
  end
end
