require 'spec_helper'

describe Kindle, :vcr do
  context "security question", irregular: true do
    it "fetches highlights with correct phone number" do
      k = Kindle::Highlights.new(credentials)
      highlights = k.fetch_highlights
      expect(highlights.size).to be > 0
    end

    it "raises error with wrong phone number" do
      with_env_vars 'PHONE_NUMBER' => '99912345678' do
        k = Kindle::Highlights.new(credentials)
        expect{
          k.fetch_highlights
        }.to raise_error(Kindle::SecurityQuestionFailed)
      end
    end
  end
end
