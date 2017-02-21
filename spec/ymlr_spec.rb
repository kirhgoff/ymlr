require "spec_helper"

RSpec.describe Ymlr do
  it "has a version number" do
    expect(Ymlr::VERSION).not_to be nil
  end

  it "able to find duplicates" do
    finder = Ymlr::DuplicatesFinder.new
    result = finder.find_duplicates(
      "spec/fixtures/sample1_simple.yml",
      "spec/fixtures/sample2_simple.yml",
    )
    expect(result).not_to be_nil
    expect(result.duplicates.keys).to contain_exactly(".root.keyB")
  end
end
