require './santa_matcher.rb'
require './santa_list.rb'

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

def matcher_1; SantaMatcher.new(SantaList.new(name_lists[1]).list_check); end
def matcher_2; SantaMatcher.new(SantaList.new(name_lists[2]).list_check); end
def matcher_3; SantaMatcher.new(SantaList.new(name_lists[3]).list_check); end


describe "SantaMatcher" do
  describe "#eliminate_family" do
    it "returns an array of names/emails with family members removed" do

      expect(matcher_3.eliminate_family("Skywalker")).to match_array([["Toula", "Portokalos", "<toula@manhunter.org>"],
        ["Gus", "Portokalos", "<gus@weareallfruit.net>"], ["Bruce", "Wayne", "<bruce@imbatman.com>"],
        ["Virgil", "Brigman", "<virgil@rigworkersunion.org>"], ["Lindsey", "Brigman", "<lindsey@iseealiens.net>"]])
      expect(matcher_3.eliminate_family("Portokalos")).to match_array([["Luke", "Skywalker", "<luke@theforce.net>"],
        ["Leia", "Skywalker", "<leia@therebellion.org>"], ["Bruce", "Wayne", "<bruce@imbatman.com>"],
        ["Virgil", "Brigman", "<virgil@rigworkersunion.org>"], ["Lindsey", "Brigman", "<lindsey@iseealiens.net>"]])
    end
  end
  describe "#make_matches" do
    it "takes in a list of names and returns an array with assignments" do
      expect(matcher_2.make_matches.size).to eq 3
      expect(matcher_2.make_matches.first.size).to eq 2
      expect(matcher_2.make_matches.class).to eq Array
    end

    it "prevents assignment when impossible due to >50% presence of last name" do
      expect {matcher_1.make_matches}.to raise_error(ArgumentError, "Assignment Impossible")
    end

    it "only assigns each person to one secret santa, and each santa to one person" do
      matches = matcher_3.make_matches
      santas = matches.map{|match| match[0]}
      recipients = matches.map{|match| match[1]}

      expect(santas.uniq.size).to eq matches.size
      expect(recipients.uniq.size).to eq matches.size
    end

    it "does not assign santas to a member of own family" do
      matches = matcher_3.make_matches
      santa_last_names = matches.map{|match| match[0]}.map{|name| name[1]}
      recipient_last_names = matches.map{|match| match[1]}.map{|name| name[1]}
      last_name_pairs = santa_last_names.zip(recipient_last_names)

      expect(last_name_pairs.any?{|pair| pair.uniq.size<2}).to eq false
    end
  end
end
