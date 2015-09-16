def str_to_list(str)
  str.split("\n").map{|s| s.split(" ")}
end

def santa_matcher(santas) #takes in array from str_to_list
  matches = []
  recipients = list_check(santas)
  santas.each do |name|
    assigned = matches.map{|match| match[1][2]}
    options = eliminate_family(recipients, name[1]).delete_if{|option| assigned.include?(option[2])}
    matches<<[name, options.sample]
  end
  matches.any?{|match| match[1] == nil} ? santa_matcher(santas) : matches
end

def list_check(names) #takes in array from str_to_list
  size = names.count/2
  names.group_by{|name| name[1]}.each do |k, v|
    raise ArgumentError, "Assignment Impossible" if v.count > size
  end
end

def eliminate_family(names, name) #takes in hash from list_check
  return names.reject{|k,v| k==name}.values.flatten(1)
end
