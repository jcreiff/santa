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

def list_1; SantaList.new(name_lists[1]); end
def list_2; SantaList.new(name_lists[2]); end
def list_3; SantaList.new(name_lists[3]); end

describe "SantaList" do
  describe "#input_to_list" do
    it "returns an array with each person's info in a sub-array" do
      expect(list_1.input_to_list).to match_array([["Luke", "Skywalker", "<luke@theforce.net>"],
      ["Leia", "Skywalker", "<leia@therebellion.org>"]])
      expect(list_1.input_to_list.length).to eq 2
    end
  end

  describe "#list_check" do
    it "returns a hash of names grouped by last names" do
      result = {"Skywalker"=>[["Luke", "Skywalker", "<luke@theforce.net>"], ["Leia", "Skywalker", "<leia@therebellion.org>"]],
       "Portokalos"=>[["Toula", "Portokalos", "<toula@manhunter.org>"], ["Gus", "Portokalos", "<gus@weareallfruit.net>"]],
       "Wayne"=>[["Bruce", "Wayne", "<bruce@imbatman.com>"]],
       "Brigman"=>[["Virgil", "Brigman", "<virgil@rigworkersunion.org>"], ["Lindsey", "Brigman", "<lindsey@iseealiens.net>"]]}

      expect(list_3.list_check).to match_array(result)
    end

    it "raises error when list provided has >50% of one last name" do
      expect {list_1.list_check}.to raise_error(ArgumentError, "Assignment Impossible")
    end
  end
end
