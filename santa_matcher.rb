class SantaMatcher
  attr_reader :santa_list

  def initialize(santa_list)
    @santa_list = santa_list
  end

  def eliminate_family(name) #uses hash from santa_list
    santa_list.reject{|k,v| k==name}.values.flatten(1)
  end

  def make_matches #uses array from SantaList#list_check
    matches = []
    santa_list.each do |name|
      assigned_emails = matches.map{|match| match[1][2]}
      options = eliminate_family(name[1])
      options.delete_if{|option| assigned_emails & [option[2]] != []}
      matches<<[name, options.sample]
    end
    matches.flatten.any?{|match| match == nil} ? make_matches(santa_list) : matches
  end

end
