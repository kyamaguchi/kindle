require 'spec_helper'
require 'open-uri'

describe Kindle, :vcr do
  it "true" do
    page = open('http://www.google.com/')
    expect(page).to_not be_nil
  end
end
