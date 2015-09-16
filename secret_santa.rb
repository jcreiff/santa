def str_to_list(str)
  str.split("\n").map{|s| s.split(" ")}
end

def santa_matcher(info)
  matches = []
  info.each_with_index do |name, i|
    if info[i+1] != nil
      matches<<[name, info[i+1]]
    else
      matches<<[name, info[0]]
    end
  end
  matches
end

names = "Luke Skywalker <luke@theforce.net>\nLeia Skywalker <leia@therebellion.org>\n\
Toula Portokalos <toula@manhunter.org>\nGus Portokalos <gus@weareallfruit.net>\n\
Bruce Wayne <bruce@imbatman.com>\nVirgil Brigman <virgil@rigworkersunion.org>\n\
Lindsey Brigman <lindsey@iseealiens.net>"