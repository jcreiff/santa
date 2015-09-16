require 'rspec'
require './spec/spec_helper.rb'
require './secret_santa.rb'
require 'byebug'

def name_lists
  {
    1=>"Luke Skywalker <luke@theforce.net>\nLeia Skywalker <leia@therebellion.org>\n",
    2=>"Gus Portokalos <gus@weareallfruit.net>\n\
    Bruce Wayne <bruce@imbatman.com>\nVirgil Brigman <virgil@rigworkersunion.org>\n",
    3=>"Luke Skywalker <luke@theforce.net>\nLeia Skywalker <leia@therebellion.org>\n\
    Toula Portokalos <toula@manhunter.org>\nGus Portokalos <gus@weareallfruit.net>\n\
    Bruce Wayne <bruce@imbatman.com>\nVirgil Brigman <virgil@rigworkersunion.org>\n\
    Lindsey Brigman <lindsey@iseealiens.net>"
  }
end

describe "string to list method" do
  it "returns an array with each person's info in a sub-array" do
    expect(str_to_list(name_lists[1])).to eq([["Luke", "Skywalker", "<luke@theforce.net>"],
    ["Leia", "Skywalker", "<leia@therebellion.org>"]])
    expect(str_to_list(name_lists[1]).length).to eq 2
  end
end

describe "santa matcher method" do
  it "takes in a list of names and returns an array with assignments" do
    list = str_to_list(name_lists[2])

    expect(santa_matcher(list).size).to eq 3
    expect(santa_matcher(list).first.size).to eq 2
    expect(santa_matcher(list).class).to eq Array
  end

  it "prevents assignment when impossible due to >50% presence of last name" do
    list = str_to_list(name_lists[1])

    expect {santa_matcher(list)}.to raise_error(ArgumentError, "Assignment Impossible")
  end

  it "only assigns each person to one secret santa, and each santa to one person" do
    list = str_to_list(name_lists[3])
    matches = santa_matcher(list)
    santas = matches.map{|match| match[0]}
    recipients = matches.map{|match| match[1]}

    expect(santas.uniq.size).to eq list.size
    expect(recipients.uniq.size).to eq list.size
  end

  it "does not assign santas to a member of own family" do
    list = str_to_list(name_lists[3])
    matches = santa_matcher(list)
    santa_last_names = matches.map{|match| match[0]}.map{|name| name[1]}
    recipient_last_names = matches.map{|match| match[1]}.map{|name| name[1]}
    last_name_pairs = santa_last_names.zip(recipient_last_names)

    expect(last_name_pairs.any?{|pair| pair.uniq.size<2}).to eq false
  end
end

describe "list check method" do
  it "returns a hash of names grouped by last names" do
    list = str_to_list(name_lists[3])
    result = {"Skywalker"=>[["Luke", "Skywalker", "<luke@theforce.net>"], ["Leia", "Skywalker", "<leia@therebellion.org>"]],
     "Portokalos"=>[["Toula", "Portokalos", "<toula@manhunter.org>"], ["Gus", "Portokalos", "<gus@weareallfruit.net>"]],
     "Wayne"=>[["Bruce", "Wayne", "<bruce@imbatman.com>"]],
     "Brigman"=>[["Virgil", "Brigman", "<virgil@rigworkersunion.org>"], ["Lindsey", "Brigman", "<lindsey@iseealiens.net>"]]}

    expect(list_check(list)).to eq result
  end

  it "raises error when list provided has >50% of one last name" do
    list = str_to_list(name_lists[1])

    expect {list_check(list)}.to raise_error(ArgumentError, "Assignment Impossible")
  end
end

describe "eliminate family method" do
  it "returns an array of names/emails with family members removed" do
    list = str_to_list(name_lists[3])
    hash = list_check(list)

    expect(eliminate_family(hash, "Skywalker")).to eq([["Toula", "Portokalos", "<toula@manhunter.org>"],
      ["Gus", "Portokalos", "<gus@weareallfruit.net>"], ["Bruce", "Wayne", "<bruce@imbatman.com>"],
      ["Virgil", "Brigman", "<virgil@rigworkersunion.org>"], ["Lindsey", "Brigman", "<lindsey@iseealiens.net>"]])
    expect(eliminate_family(hash, "Portokalos")).to eq([["Luke", "Skywalker", "<luke@theforce.net>"],
      ["Leia", "Skywalker", "<leia@therebellion.org>"], ["Bruce", "Wayne", "<bruce@imbatman.com>"],
      ["Virgil", "Brigman", "<virgil@rigworkersunion.org>"], ["Lindsey", "Brigman", "<lindsey@iseealiens.net>"]])
  end
end
