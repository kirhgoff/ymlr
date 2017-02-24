require "spec_helper"

RSpec.describe Ymlr do
  it "has a version number" do
    expect(Ymlr::VERSION).not_to be nil
  end

  it "able to find find differences" do
    finder = Ymlr::DuplicatesFinder.new
    result = finder.find_duplicates(
      "spec/fixtures/sample1_simple.yml",
      "spec/fixtures/sample2_simple.yml",
    )
    expect(result).not_to be_nil
    expect(result.duplicates.keys).to contain_exactly(%w(root keyB))
    expect(result.overrides).to eq({%w(root2 keyD) => %w(valueD1 valueD2)})
    expect(result.missed_first).to eq({%w(root keyA) => 'valueA'})
    expect(result.missed_second).to eq({%w(root keyC) => 'valueC'})
  end
end
