require 'rspec'
require './spec/spec_helper.rb'
require './secret_santa.rb'

describe "takes in a string as input and returns output" do
  it "returns an array with each person's info in a sub-array" do
    names = "Luke Skywalker <luke@theforce.net>\nLeia Skywalker <leia@therebellion.org>\n"

    expect(str_to_list(names)).to eq([["Luke", "Skywalker", "<luke@theforce.net>"],
    ["Leia", "Skywalker", "<leia@therebellion.org>"]])
    expect(str_to_list(names).length).to eq 2
  end
end

describe "each person is assigned a secret santa" do
  it "takes in a list of names and returns an array with assignments" do
    names = "Gus Portokalos <gus@weareallfruit.net>\n\
    Bruce Wayne <bruce@imbatman.com>\nVirgil Brigman <virgil@rigworkersunion.org>\n"
    list = str_to_list(names)

    expect(santa_matcher(list).size).to eq 3
    expect(santa_matcher(list).first).to eq [["Gus", "Portokalos", "<gus@weareallfruit.net>"],
     ["Bruce", "Wayne", "<bruce@imbatman.com>"]]
  end
end
